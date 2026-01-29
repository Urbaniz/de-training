import json
import psycopg2
from confluent_kafka import Producer

PG_DSN = 'host=localhost port=5434 dbname=db user=user password=password'

KAFKA_BOOTSTRAP = 'localhost:29092'
TOPIC = 'pg_source_events'

producer = Producer({'bootstrap.servers': KAFKA_BOOTSTRAP})

conn = psycopg2.connect(PG_DSN)
cur = conn.cursor()
cur.execute('''
    select user_id, url, response_time, status_code
    from web_logs;
''')

count = 0
for (user_id, url, response_time, status_code) in cur.fetchall():
    msg = {
        'user_id': int(user_id) if user_id is not None else None,
        'url': url,
        'response_time': int(response_time) if response_time is not None else None,
        'status_code': int(status_code) if status_code is not None else None,
    }

    producer.produce(
        TOPIC,
        key=str(msg['user_id']) if msg['user_id'] is not None else None,
        value=json.dumps(msg, ensure_ascii=False).encode('utf-8'),
    )
    count += 1

producer.flush()
cur.close()
conn.close()

print(f"{count} rows to '{TOPIC}'")
