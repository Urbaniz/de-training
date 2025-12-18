INSERT INTO customers (name, email, phone) VALUES
('Сергей', 'segrey@yandex.ru', '123-123'),
('Анастасия', null, '85614529574'),
('Виктор',   'vvv@gmail.com',   null);

INSERT INTO products (product_name, category) VALUES
('Ноутбук', 'Электроника'),
('Наушники', 'Элекроника'),
('Макароны', 'Бакалея'),
('Рис',   'Бакалея');

INSERT INTO sales (customer_id, product_id, sale_date, amount, quantity) VALUES
(1, 3, '2025-05-10', 1000.00, 10),
(2, 1, '2025-08-25', 80999.00, 1),
(1, 2, '2025-10-03', 1999.00, 1),
(3, 4, '2025-10-11',  500.00, 6),
(2, 3, '2025-10-12',  300.00, 3);