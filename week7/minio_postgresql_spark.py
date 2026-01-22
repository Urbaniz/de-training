from pyspark.sql import SparkSession
from pyspark.sql.functions import current_timestamp

S3_ENDPOINT = 'http://host.docker.internal:9000'
S3_ACCESS_KEY = 'minio'
S3_SECRET_KEY = 'miniopassword'

PG_URL = 'jdbc:postgresql://host.docker.internal:5434/db'
PG_USER = 'user'
PG_PASSWORD = 'password'

PATH_MINIO = 's3a://lake/parquet/'

spark = (
    SparkSession.builder
    .appName('two-parquets-to-postgres')
    .config('spark.hadoop.fs.s3a.endpoint', S3_ENDPOINT)
    .config('spark.hadoop.fs.s3a.access.key', S3_ACCESS_KEY)
    .config('spark.hadoop.fs.s3a.secret.key', S3_SECRET_KEY)
    .config('spark.hadoop.fs.s3a.path.style.access', 'true')
    .config('spark.hadoop.fs.s3a.connection.ssl.enabled', 'false')
    .getOrCreate()
)

df = spark.read.parquet(PATH_MINIO)
df = df.withColumn('loan_dt', current_timestamp())

(df.write
    .format('jdbc')
    .option('url', PG_URL)
    .option('dbtable', 'public.parquet_spark')
    .option('user', PG_USER)
    .option('password', PG_PASSWORD)
    .option('driver', 'org.postgresql.Driver')
    .mode('append')
    .save()
)

spark.stop()