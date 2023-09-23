CREATE TABLE users (
	id INTEGER PRIMARY KEY,
	user_name VARCHAR,
	display_picture VARCHAR,
	created_at TIMESTAMP,
	followers INTEGER
);

CREATE TABLE authors (
	id INTEGER PRIMARY KEY,
	user_id INTEGER FOREIGN KEY REFERENCES users(id),
	author_name VARCHAR,
	display_picture VARCHAR,
 	created_at TIMESTAMP
);

CREATE TABLE user_followers (
	user_id INTEGER FOREIGN KEY REFERENCES users(id),
	follwing_id INTEGER FOREIGN KEY REFERENCES users(id),
  PRIMARY KEY (user_id, follwing_id)
);

CREATE TABLE books (
	id INTEGER PRIMARY KEY,
	isbn bigint UNIQUE,
	title VARCHAR,
	subtitle VARCHAR,
	topic VARCHAR,
	rating INTEGER,
	cover_page VARCHAR,
 	published_at TIMESTAMP,
	upvote_user_ids INTEGER,
	downvote_user_ids INTEGER,
	created_at TIMESTAMP
);

CREATE TABLE book_authors (
	id INTEGER PRIMARY KEY,
	book_id INTEGER FOREIGN KEY REFERENCES books(id),
	author_id INTEGER FOREIGN KEY REFERENCES authors(id),
  PRIMARY KEY (books_author_id, authors_id)
);

CREATE TABLE book_reads (
	user_id INTEGER FOREIGN KEY REFERENCES users(id),
	book_id INTEGER FOREIGN KEY REFERENCES books(id),
	created_at TIMESTAMP
  PRIMARY KEY (user_id, book_id)
);

CREATE TABLE book_votes (
  user_id INTEGER FOREIGN KEY REFERENCES users(id),
	book_id INTEGER FOREIGN KEY REFERENCES books(id),
  PRIMARY KEY (user_id, book_id),
  upvote BOOLEAN
);

CREATE TABLE reviews (
  user_id INTEGER FOREIGN KEY REFERENCES users(id),
  book_id INTEGER,
  PRIMARY KEY (user_id, book_id)
  rating INTEGER,
  title VARCHAR,
  content text,
  upvote_user_ids INTEGER,
  downvote_user_ids INTEGER,
  created_at TIMESTAMP
);

CREATE TABLE review_votes (
  FOREIGN KEY (review_user_id, book_id) REFERENCES reviews(user_id, book_id),
  user_id INTEGER FOREIGN KEY REFERENCES user(id),
  PRIMARY KEY (user_id, review_user_id, book_id),
  upvote BOOLEAN
);

CREATE TABLE comments (
  FOREIGN KEY (review_user_id, book_id) REFERENCES reviews(user_id, book_id),
  user_id INTEGER FOREIGN KEY REFERENCES users(id),
  PRIMARY KEY (user_id, review_user_id, book_id),
  title VARCHAR,
  content VARCHAR,
  created_at TIMESTAMP
);

CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  user_id INTEGER FOREIGN KEY REFERENCES users(id),
  book_id INTEGER ,
  title VARCHAR,
  content text,
  upvote_user_ids INTEGER,
  downvote_user_ids INTEGER,
  created_at TIMESTAMP
);

CREATE TABLE book_votes (
  user_id INTEGER FOREIGN KEY REFERENCES users(id),
	post_id INTEGER FOREIGN KEY REFERENCES posts(id),
  PRIMARY KEY (user_id, book_id),
  upvote BOOLEAN
);
