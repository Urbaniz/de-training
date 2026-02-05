from datetime import datetime

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

SQL = """
    create table if not exists web_logs_loaded (
      timestamp timestamp,
      user_id int,
      url varchar(256),
      response_time int,
      status_code int,
      source_file varchar(256),
      ingest_ts timestamp default now()
    );
    
    create table if not exists file_status (
      file_name varchar(256) primary key,
      loaded_at timestamp,
      file_rows int,         
      checked_at timestamp,          
      table_rows int,              
      same boolean         
    );
"""

with DAG(
    dag_id="init_tables",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    PostgresOperator(
        task_id="create_tables_if_not_exists",
        postgres_conn_id="pg_target",
        sql=SQL,
    )