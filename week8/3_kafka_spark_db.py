from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json, current_timestamp
from pyspark.sql.types import StructType, StructField, IntegerType, StringType

KAFKA_BOOTSTRAP = 'kafka:9092'
TOPIC = 'pg_source_events'

PG_URL = 'jdbc:postgresql://postgres:5432/db'
PG_USER = 'user'
PG_PASSWORD = 'password'
PG_TABLE = 'web_logs_sink'

CHECKPOINT = '/tmp/checkpoints/pg_source_events'

schema = StructType([
    StructField('user_id', IntegerType(), True),
    StructField('url', StringType(), True),
    StructField('response_time', IntegerType(), True),
    StructField('status_code', IntegerType(), True),
])

spark = (
    SparkSession.builder
    .appName('kafka-to-postgres')
    .getOrCreate()
)
raw = (
    spark.readStream
    .format('kafka')
    .option('kafka.bootstrap.servers', KAFKA_BOOTSTRAP)
    .option('subscribe', TOPIC)
    .option('startingOffsets', 'earliest')
    .load()
)

parsed = (
    raw.select(from_json(col('value').cast('string'), schema).alias('j'))
       .select('j.*')
       .withColumn('import_ts', current_timestamp())
)

def write_to_pg(batch_df, batch_id: int):
    (batch_df.write
        .format('jdbc')
        .option('url', PG_URL)
        .option('dbtable', PG_TABLE)
        .option('user', PG_USER)
        .option('password', PG_PASSWORD)
        .option('driver', 'org.postgresql.Driver')
        .mode('append')
        .save()
    )

query = (
    parsed.writeStream
    .foreachBatch(write_to_pg)
    .option('checkpointLocation', CHECKPOINT)
    .start()
)

query.awaitTermination()