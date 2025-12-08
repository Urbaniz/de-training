--Основные операции CRUD
--Чтение всех книг с информацией об авторах
select a.*, b.*
from books b join authors a on a.author_id = b.author_id;

--Обновление информации о читателе
update readers
set address = 'Широкая улица, 48, 5'
where reader_id = 2;

--Удаление книги
-- тк у меня не прописано каскадное удаление млм можно использовать доп столбец-флаг для 'удаления'
delete from loans  
where book_id = 26;

delete from books 
where book_id = 26;


--Работа с NULL
--Выбор всех заказов с указанием даты возврата или значения по умолчанию
select loan_id,
	book_id,
	reader_id,
	loan_date,
	return_date,
	case
		when return_date is null then due_date
		else return_date
	end as return_date_new
from loans;


--Использование UNION vs UNION ALL
--Объединение списков читателей и авторов
--без дублей
select 'reader' as role,
    full_name_reader as full_name
from readers
union
select 'author' as role,
    full_name_author as full_name
from authors;

--с дублями
select 'reader' as role,
    full_name_reader as full_name
from readers
union all
select 'author' as role,
    full_name_author as full_name
from authors;


--CTE и рекурсивные запросы
--Создание иерархического запроса для получения всех книг и их авторов
--без рекукрсии
with books_authors as (
    select a.full_name_author, 
    	b.title
    from books b join authors a on b.author_id = a.author_id
)
select *
from books_authors
order by full_name_author, title;

--с рекукрсией
with recursive author_books as (
    select a.author_id,
        a.full_name_author as author_name,
        ''::text as book_title,
        1 as level
    from authors a
    union all
    select ab.author_id,
        ab.author_name,
        b.title as book_title,
        2 as level
    from books b join author_books ab on ab.author_id = b.author_id and ab.level = 1
)
select level, 
	author_name, 
	book_title
from author_books
order by author_name, level, book_title;


--Оконные функции
--Использование оконных функций для нумерации заказов
select *,  
	row_number() over (order by loan_id) as row
from loans;


