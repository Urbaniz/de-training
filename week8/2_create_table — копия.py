import psycopg2

conn = psycopg2.connect(
    dbname='db',
    user='user',
    password="password",
    host='localhost',
    port="5434"
)
cur = conn.cursor()
cur.execute("""
    create table if not exists logs_kafka (
        user_id int,
        url varchar (40),
        response_time int,
        status_code int,
        import_ts timestamp not null);
""")
conn.commit()
cur.close()
conn.close()