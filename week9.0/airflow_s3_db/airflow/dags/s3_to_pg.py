from datetime import timezone, datetime

import pyarrow.parquet as pq

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from airflow.providers.postgres.hooks.postgres import PostgresHook


BUCKET = "lake"
PREFIX = "parquet/"
PG_TABLE = "web_logs_loaded"
STATUS_TABLE = "file_status"


def load_one_new_file():
    pg = PostgresHook(postgres_conn_id="pg_target")
    s3 = S3Hook(aws_conn_id="s3")

    loaded_rows = pg.get_records(f"select file_name from {STATUS_TABLE} where loaded_at is not null")
    loaded = {r[0] for r in loaded_rows}

    keys = s3.list_keys(bucket_name=BUCKET, prefix=PREFIX) or []
    keys = [k for k in keys if k.endswith(".parquet")]

    new_keys = [k for k in sorted(keys) if k not in loaded]
    if not new_keys:
        return

    key = new_keys[0]

    local_file = "/tmp/input.parquet"
    s3.get_key(key, BUCKET).download_file(local_file)

    df = pq.read_table(local_file).to_pandas()
    df["source_file"] = key
    df["ingest_ts"] = datetime.now(timezone.utc).replace(tzinfo=None)
    df = df.drop(columns=["day", "is_error"], errors="ignore")

    engine = pg.get_sqlalchemy_engine()
    df.to_sql(
        name="web_logs_loaded",
        schema="public",
        con=engine,
        if_exists="append",
        index=False,
    )

    pg.run(
        f"""
        insert into {STATUS_TABLE}(file_name, loaded_at, file_rows)
        values (%s, now(), %s)
        on conflict (file_name) do nothing
        """,
        parameters=(key, len(df)),
    )


with DAG(
    dag_id="s3_to_pg",
    start_date=datetime(2024, 1, 1),
    schedule="0 * * * *",
    catchup=False,
) as dag:
    PythonOperator(task_id="load_one_new_file", python_callable=load_one_new_file)