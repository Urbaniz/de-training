import pandas as pd
from sqlalchemy import create_engine
import datetime

start = datetime.datetime.now()
print('Время старта: ' + str(start))

S3_ENDPOINT = 'http://localhost:9000'
S3_ACCESS_KEY = 'minio'
S3_SECRET_KEY = 'miniopassword'
PATH_MINIO = 's3://lake/parquet/logs.parquet'

PG_HOST = 'localhost'
PG_PORT = 5434
PG_DB = 'db'
PG_USER = 'user'
PG_PASS = 'password'
PG_TABLE = 'public.parquet_py'

df = pd.read_parquet(
    PATH_MINIO,
    engine='pyarrow',
    storage_options={
        'key': S3_ACCESS_KEY,
        'secret': S3_SECRET_KEY,
        'client_kwargs': {'endpoint_url': S3_ENDPOINT},
    },
)

df['loan_dt'] = pd.Timestamp.today()

engine = create_engine(
    f'postgresql+psycopg2://{PG_USER}:{PG_PASS}@{PG_HOST}:{PG_PORT}/{PG_DB}',
    pool_pre_ping=True,
)

schema, table = PG_TABLE.split('.', 1)
df.to_sql(
    name=table,
    schema=schema,
    con=engine,
    if_exists='append',
    index=False,
    method='multi',
)

finish = datetime.datetime.now()
print('Время окончания: ' + str(finish))