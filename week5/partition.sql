CREATE TABLE web_logs_partit
(
  timestamp DateTime,
  user_id UInt64,
  url String,
  response_time UInt32,
  status_code UInt16
)ENGINE = MergeTree PARTITION BY toYYYYMM(timestamp)
ORDER BY timestamp;


INSERT INTO web_logs_partit SELECT * FROM web_logs;