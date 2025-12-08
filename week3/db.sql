CREATE TABLE readers(
    reader_id SERIAL PRIMARY KEY,
    full_name_reader VARCHAR(150) NOT NULL,
    birth_date DATE,
    address VARCHAR(255),
    phone VARCHAR(255),
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE authors(
    author_id SERIAL PRIMARY KEY,
    full_name_author VARCHAR(255) UNIQUE NOT NULL,
    country VARCHAR(100)
);

CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name VARCHAR(255) UNIQUE,
    publisher_city VARCHAR(100),
    phone VARCHAR(100),
    email VARCHAR(100)
    );

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE languages (
    language_id SERIAL PRIMARY KEY,
    language VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    author_id INTEGER NOT NULL REFERENCES authors(author_id),
    title VARCHAR(255) NOT NULL,
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    genre_id INTEGER NOT NULL REFERENCES genres(genre_id),
    publication_date VARCHAR(10),
    language_id INTEGER NOT NULL REFERENCES languages(language_id)
);

CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    reader_id INTEGER NOT NULL REFERENCES readers(reader_id),
    loan_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE GENERATED ALWAYS AS (loan_date + 30) STORED,
    return_date DATE,
    status TEXT NOT NULL CHECK (status IN ('open', 'returned', 'overdue'))
);