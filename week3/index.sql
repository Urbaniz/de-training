create index books_author_id_index on books(author_id);

create index books_publisher_id_index on books(publisher_id);

create index books_genre_id_index on books(genre_id);

create index books_language_id_index on books(language_id);

create index loans_book_id_index on loans(book_id);

create index loans_reader_id on loans(reader_id);

create index loans_loan_date_index on loans(loan_date);

create index loans_status_index on loans(status);

create index loans_status_due_date_index on loans(status, due_date);