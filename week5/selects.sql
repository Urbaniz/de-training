SELECT count(*)
FROM web_logs;

--Найдите общее количество запросов за каждый день.
SELECT toDate(timestamp) AS day,
  count(*) AS total_requests
FROM web_logs
GROUP BY day
ORDER BY total_requests;

--Определите среднее время ответа для каждого URL.
SELECT url,
  rounD(avg(response_time), 2) AS avg_response_time
FROM web_logs
GROUP BY url;

--Подсчитайте количество запросов с ошибками (например, статус-коды 4xx и 5xx).
SELECT
  status_code,
  count() AS total_requests
FROM web_logs
WHERE status_code >= 400
GROUP BY status_code;

--Найдите топ-10 пользователей по количеству запросов.
SELECT user_id,
  count(*) AS requests
FROM web_logs
GROUP BY user_id
ORDER BY requests DESC
LIMIT 10;
