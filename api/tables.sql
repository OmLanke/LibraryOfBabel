CREATE TABLE IF NOT EXISTS users (
	id SERIAL PRIMARY KEY,
	user_name VARCHAR,
	user_type VARCHAR,
	verified BOOLEAN,
	display_picture VARCHAR,
	created_at TIMESTAMP DEFAULT current_timestamp,
	followers INTEGER
);

CREATE TABLE IF NOT EXISTS authors (
	id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES users(id),
	author_name VARCHAR,
	display_picture VARCHAR,
 	created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS user_followers (
	user_id INTEGER REFERENCES users(id),
	follwing_id INTEGER REFERENCES users(id),
	PRIMARY KEY (user_id, follwing_id)
);

CREATE TABLE IF NOT EXISTS books (
	id SERIAL PRIMARY KEY,
	isbn bigint UNIQUE NULL,
	title VARCHAR,
	subtitle VARCHAR NULL,
	book_description TEXT,
	topic VARCHAR,
	rating REAL,
	weighted_rating REAL,
	cover_page VARCHAR,
 	published_at TIMESTAMP NULL,
	created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS book_authors (
	id SERIAL PRIMARY KEY,
	book_id INTEGER REFERENCES books(id),
	author_id INTEGER REFERENCES authors(id)
);

CREATE TABLE IF NOT EXISTS book_reads (
	user_id INTEGER REFERENCES users(id),
	book_id INTEGER REFERENCES books(id),
	created_at TIMESTAMP DEFAULT current_timestamp,
	PRIMARY KEY (user_id, book_id)
);

CREATE TABLE IF NOT EXISTS book_votes (
	user_id INTEGER REFERENCES users(id),
	book_id INTEGER REFERENCES books(id),
	PRIMARY KEY (user_id, book_id),
	upvote BOOLEAN
);

CREATE TABLE IF NOT EXISTS reviews (
	user_id INTEGER REFERENCES users(id),
	book_id INTEGER,
	PRIMARY KEY (user_id, book_id),
	rating REAL,
	weighted_rating REAL,
	title VARCHAR,
	content TEXT,
	created_at TIMESTAMP DEFAULT current_timestamp
);

-- didnt work
CREATE TABLE IF NOT EXISTS review_votes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    review_user_id INTEGER,
    book_id INTEGER,
    upvote BOOLEAN,
    FOREIGN KEY (review_user_id, book_id) REFERENCES reviews(user_id, book_id),
    created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
	review_user_id INTEGER,
	book_id INTEGER,
    FOREIGN KEY (review_user_id, book_id) REFERENCES reviews(user_id, book_id),
	title VARCHAR,
	content VARCHAR,
	created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES users(id),
	book_id INTEGER REFERENCES books(id),
	title VARCHAR,
	content TEXT,
	created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS post_votes (
	user_id INTEGER REFERENCES users(id),
	post_id INTEGER REFERENCES posts(id),
	PRIMARY KEY (user_id, post_id),
	upvote BOOLEAN
);
