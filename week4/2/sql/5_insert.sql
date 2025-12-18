insert into customers (name, email, phone) values
	('Алена',  NULL, NULL),
	('Сергей',  'po@po.po',  '485212');

insert into products (product_name, category, price) values
	('Картошка',  'Овощи', 105.2),
	('Морковь',  'Овощи',  75.6),
	('Мандарины',  'Фрукты', 165.6);

insert into order_statuses (status_name, description) values
	('NEW',  'Новый заказ'),
	('CLOSED',  'Заказ закрыт'),
	('PAID',  'Заказ оплачивается');


INSERT INTO orders (customer_id, product_id, status_name, order_date, total_amount, quantity)
VALUES
  (1, 1, 'CLOSED',  '2020-03-10', 105.2, 1),
  (2, 2, 'CLOSED',  '2023-03-10', 75.6, 1),
  (1, 3, 'NEW',  '2024-03-10', 165.6, 1),
  (2, 1, 'PAID',  '2025-07-01',  105.2, 2);