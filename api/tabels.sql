CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	user_name VARCHAR,
	display_picture VARCHAR,
	created_at TIMESTAMP,
	followers INTEGER
);

CREATE TABLE authors (
	id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES users(id),
	author_name VARCHAR,
	display_picture VARCHAR,
 	created_at TIMESTAMP
);

CREATE TABLE user_followers (
	user_id INTEGER REFERENCES users(id),
	follwing_id INTEGER REFERENCES users(id),
	PRIMARY KEY (user_id, follwing_id)
);

CREATE TABLE books (
	id SERIAL PRIMARY KEY,
	isbn bigint UNIQUE,
	title VARCHAR,
	subtitle VARCHAR,
	topic VARCHAR,
	rating INTEGER,
	cover_page VARCHAR,
 	published_at TIMESTAMP,
	created_at TIMESTAMP
);

CREATE TABLE book_authors (
	id SERIAL PRIMARY KEY,
	book_id INTEGER REFERENCES books(id),
	author_id INTEGER REFERENCES authors(id),
	PRIMARY KEY (books_author_id, authors_id)
);

CREATE TABLE book_reads (
	user_id INTEGER REFERENCES users(id),
	book_id INTEGER REFERENCES books(id),
	created_at TIMESTAMP
	PRIMARY KEY (user_id, book_id)
);

CREATE TABLE book_votes (
	user_id INTEGER REFERENCES users(id),
	book_id INTEGER REFERENCES books(id),
	PRIMARY KEY (user_id, book_id),
	upvote BOOLEAN
);

CREATE TABLE reviews (
	user_id INTEGER REFERENCES users(id),
	book_id INTEGER,
	PRIMARY KEY (user_id, book_id),
	rating REAL,
	weighted_rating REAL,
	title VARCHAR,
	content text,
	created_at TIMESTAMP
);

-- didnt work
CREATE TABLE review_votes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    review_user_id INTEGER,
    book_id INTEGER,
    upvote BOOLEAN,
    FOREIGN KEY (review_user_id, book_id) REFERENCES reviews(user_id, book_id),
    created_at TIMESTAMP
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
	review_user_id INTEGER,
	book_id INTEGER,
    FOREIGN KEY (review_user_id, book_id) REFERENCES reviews(user_id, book_id),
	title VARCHAR,
	content VARCHAR,
	created_at TIMESTAMP
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES users(id),
	book_id INTEGER REFERENCES books(id),
	title VARCHAR,
	content text,
	created_at TIMESTAMP
);

CREATE TABLE post_votes (
	user_id INTEGER REFERENCES users(id),
	post_id INTEGER REFERENCES posts(id),
	PRIMARY KEY (user_id, post_id),
	upvote BOOLEAN
);
