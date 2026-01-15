CREATE TABLE web_logs (
	timestamp timestamp not null,
	user_id int not null,
	url varchar(256) not null,
	response_time int not null,
	status_code int not null
);


INSERT INTO web_logs VALUES 
	(now(), 124, 'https://edu.ru/image', 480, 429),
	(now(), 13, 'https://edu.ru/blog', 230, 404),
	(now(), 355, 'https://edu.ru/image', 72, 301),
	(now(), 498, 'https://edu.ru/settings', 282, 403),
	(now(), 826, 'https://edu.ru/product', 977, 204),
	(now(), 134, 'https://edu.ru/blog', 923, 301),
	(now(), 924, 'https://edu.ru/product', 516, 429),
	(now(), 83, 'https://edu.ru/blog', 319, 404),
	(now(), 924, 'https://edu.ru/blog', 118, 204),
	(now(), 224, 'https://edu.ru/image', 447, 301),
	(now(), 502, 'https://edu.ru/image', 664, 403),
	(now(), 473, 'https://edu.ru/image', 521, 404);