import config
import pandas as pd
import logging
import pyarrow as pa

import sqlalchemy as sa
import pyarrow.parquet as pq
import s3fs

from pyiceberg.catalog import load_catalog
from pyiceberg.schema import Schema
from pyiceberg.types import NestedField, TimestampType, StringType, BooleanType, DateType, LongType

logging.basicConfig(
    level=logging.INFO,
    format='[%(levelname)s] %(message)s',
)

def inicialisation_df(pg_uri):
    logging.info('Начало загрузки данных из PostgreSQL')
    try:
        engine = sa.create_engine(pg_uri)
        df = pd.read_sql('select * from web_logs', engine)

        if len(df) == 0:
            logging.error('Таблица пустая')

        logging.info('Загрузка данных завершена')
        return df
    except Exception as e:
        logging.error('Ошибка при загрузке данных из PostgreSQL')

def etl_table(df):
    logging.info('Начало преобразования данных')

    df['timestamp'] = df['timestamp'].astype('datetime64[s]')
    df['day'] = pd.to_datetime(df['timestamp']).dt.date
    df['is_error'] = df['status_code'] >= 400

    logging.info('Преобразование завершено')
    return pa.Table.from_pandas(df, preserve_index=False)

def parquet_minio(bucket, access_key, secret_key, endpoint_key, table):
    path = f'{bucket}/parquet/logs.parquet'

    logging.info(f'Сохраняем Parquet в MinIO: {path}')
    try:
        fs = s3fs.S3FileSystem(
            key=access_key,
            secret=secret_key,
            client_kwargs={'endpoint_url': endpoint_key},
            config_kwargs={'s3': {'addressing_style': 'path'}},
        )

        with fs.open(path, 'wb') as f:
            pq.write_table(table, f)
        logging.info('Parquet сохранен')
    except Exception as e:
        logging.error('Ошибка записи Parquet в MinIO')

def iceberg_minio(bucket, access_key, secret_key, endpoint_key, table):
    warehause = f"s3://{bucket}/iceberg"

    logging.info(f'Сохраняем Iceberg в MinIO: {warehause}')
    try:
        catalog = load_catalog(
            "local",
            **{
                "type": "sql",
                "uri": "sqlite:///iceberg_catalog.db",
                "warehouse": warehause,
                "s3.endpoint": endpoint_key,
                "s3.access-key-id": access_key,
                "s3.secret-access-key": secret_key,
                "s3.addressing-style": "path",
            },
        )

        catalog.create_namespace_if_not_exists("default")
        identifier = ("default", "logs_iceberg")
        schema = Schema(
            NestedField(1, "timestamp", TimestampType(), required=False),
            NestedField(2, "user_id", LongType(), required=False),
            NestedField(3, "url", StringType(), required=False),
            NestedField(4, "response_time", LongType(), required=False),
            NestedField(5, "status_code", LongType(), required=False),
            NestedField(6, "day", DateType(), required=False),
            NestedField(7, "is_error", BooleanType(), required=False),
        )

        tbl = catalog.create_table(identifier, schema=schema)
        tbl.append(table)

        logging.info('Iceberg сохранен')

    except Exception as e:
        logging.error('Ошибка записи Iceberg в MinIO')


def main():
    df = inicialisation_df(config.PG_URI)
    table = etl_table(df)

    parquet_minio(config.BUCKET, config.ACCESS_KEY, config.SECRET_KEY, config.ENDPOINT_KEY, table)
    iceberg_minio(config.BUCKET, config.ACCESS_KEY, config.SECRET_KEY, config.ENDPOINT_KEY, table)


if __name__ == "__main__":
    main()