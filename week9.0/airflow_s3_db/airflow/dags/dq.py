from datetime import datetime

import pyarrow.parquet as pq

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from airflow.providers.postgres.hooks.postgres import PostgresHook


BUCKET = "lake"
STATUS_TABLE = "file_status"
DATA_TABLE = "web_logs_loaded"


def check_rowcount():
    pg = PostgresHook(postgres_conn_id="pg_target")

    row = pg.get_first(
        f"""
        select file_name
        from {STATUS_TABLE}
        where loaded_at is not null
          and checked_at is null
        limit 1
        """
    )

    if not row:
        return

    file_name = row[0]

    s3 = S3Hook(aws_conn_id="s3")
    local_file = "/tmp/check.parquet"
    s3.get_key(file_name, BUCKET).download_file(local_file)

    parquet_rows = pq.ParquetFile(local_file).metadata.num_rows

    table_rows = pg.get_first(
        f"""
        select count(*)
        from {DATA_TABLE}
        where source_file = %s
        """,
        parameters=(file_name,),
    )[0]

    pg.run(
        f"""
        update {STATUS_TABLE}
        set checked_at = now(),
            table_rows = %s,
            same = %s
        where file_name = %s
        """,
        parameters=(table_rows, parquet_rows == table_rows, file_name),
    )


with DAG(
    dag_id="data_quality",
    start_date=datetime(2024, 1, 1),
    schedule="10 * * * *",
    catchup=False,
) as dag:
    PythonOperator(
        task_id="check_rows",
        python_callable=check_rowcount,
    )