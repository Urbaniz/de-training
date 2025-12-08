-- Вставка данных в readers
insert into readers(full_name_reader, birth_date, address, phone) values 
	('Иванов Иван Иванович', '1971-02-20', 'Майская ул, 8, 16', '89537683289'),
	('Морозов Андрей', '2006-05-19', null, null),
	('Веселова Светлана', null, 'Луговая ул., 45, 886', null);

insert into readers(full_name_reader, birth_date, address, phone, registration_date) values 
	('Семенов Сергей Игоревич', null, null, null, '2025-06-22'),
	('Петрова Оксана Игоревна', '2000-10-12', 'Советская ул., д 15б, кв 48', '354668, 896245621313', '2025-06-22'),
	('Солнечный Эдуард Петрович', '1995-12-12', null, null, '2023-12-15');

-- Вставка данных в authors
insert into authors(full_name_author, country) values
	('Лев Николаевич Толстой', null),
	('Джордж Оруэлл', 'Великобритания'),
	('Агата Кристи (Агата Мэри Кларисса Миллер)', 'Великобритания'),
	('Джон Рональд Руэл «Дж. Р. Р.» Толкин', null),
	('Александр Дюма', null),
	('Мария Семенова', 'Россия');

-- Вставка данных в publishers
insert into publishers(publisher_name, publisher_city, phone, email) values
	('Просвещение', null, null, null),
	('Вече', 'Москва', '(499) 940-48-70, (499) 940-48-71', 'veche@veche.ru'),
	('Росмэн', 'Москва', '+7 495 933-71-30', null),
	('Истари комикс', null, null, null);

-- Вставка данных в genres
insert into genres(genre_name) values 
	('Музыка, песни'), 
	('Детектив'), 
	('Роман'),
	('Жанр неизвестен'),
	('Поэма'),
	('Автобиография'),
	('Мистика и ужасы'),
	('Роман-эпопея'),
	('Повесть');

-- Вставка данных в languages
insert into languages(language) values 
	('Русский'), 
	('Английский'), 
	('Немецкий'), 
	('Французский');

-- Вставка данных в books
insert into books(author_id, title, publisher_id, genre_id, publication_date, language_id) values
	(1, 'Война и мир', null, 12, null, 1),
	(2, 'Дочь священника', 1, 7, '2008', 1),
	(2, 'Дочь священника (A Clergyman’s Daughter)', null, 7, '1998-05', 2),
	(3, 'Пуаро ведёт следствие', 3, 6, null, 1),
	(3, 'Убийства по алфавиту', 4, 6, null, 1),
	(3, 'The A.B.C. Murders', null, 6, '1955', 2),
	(4, 'Хоббит, или Туда и обратно', 3, 13, null, 1),
	(4, 'The Hobbit', null, 13, null, 2),
	(4, 'The Lord of the Rings', null, 13, null, 2),
	(5, 'Три мушкетера', 2, 7, null, 1),
	(5, '«Три мушкетёра» (фр. Les trois mousquetaires)', null, 7, '1948', 4),
	(6, 'Волкодав', 1, 7, '1995', 1);

-- Вставка данных в loans
insert into loans(book_id, reader_id, return_date, status) values
	(26, 1, current_date, 'returned'),
	(28, 6, current_date, 'returned'),
	(35, 2, current_date, 'returned');

insert into loans(book_id, reader_id, status) values
	(27, 3, 'open'),
	(30, 6, 'open'),
	(31, 5, 'open');

insert into loans(book_id, reader_id, loan_date, status) values
	(29, 3, '2023-12-21', 'overdue'),
	(37, 6, '2025-04-15', 'overdue'),
	(36, 5, '2024-09-01', 'overdue');

insert into loans(book_id, reader_id, loan_date, return_date, status) values
	(32, 2, '2025-05-05', '2025-06-05', 'returned'),
	(33, 4, '2025-04-15', '2025-09-21', 'returned'),
	(34, 4, '2024-09-01', '2024-12-21', 'returned');




