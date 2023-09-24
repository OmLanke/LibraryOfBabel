import aiohttp
import asyncpg

from datetime import datetime

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

import pathlib

import random

pics_dir = pathlib.Path.cwd().parent / "images"

class API(FastAPI):
    db: asyncpg.Pool

app = API()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup():
    app.db = await asyncpg.create_pool("postgresql://postgres:babel87775@100.65.182.43:5432/babel")
    async with app.db.acquire() as con:
        print(await con.fetch("SELECT * from users"))
    # with open('/Users/yashlanke/Desktop/Programming/Python/LibraryOfBabel/api/tables.sql', 'r') as f:
    #     async with app.db.acquire() as con:
    #         await con.execute(f.read())

@app.on_event("shutdown")
async def shutdown():
    await app.db.close()

d =  [
  {"Name": "Arogya Kalpadruma", "Color": "1"},
  {"Name": "Kumara Tantram", "Color": "2"},
  {"Name": "Arya Bhikshak", "Color": "3"},
  {"Name": "Charaka Samhita", "Color": "4"},
  {"Name": "Ashtanga Samgraha", "Color": "5"},
  {"Name": "Ayurveda Prakash", "Color": "6"},
  {"Name": "Bhaishajaya", "Color": "7"},
  {"Name": "Brihat Bhaishajya Ratnakara", "Color": "8"},
  {"Name": "Bhava Prakasha", "Color": "9"},
  {"Name":"तनय " , "color":"8"}
]

@app.get('/')
def index():
    return {'status': 'working'}

@app.get('/api/books')
async def all_books(topic: str | None = None, rating_low: float = 0, rating_high: float = 5):
    """
    Returns and filters all books
    """

    async with app.db.acquire() as con: 

        if topic is not None:
            r = await con.fetch("SELECT * FROM books WHERE weighted_rating BETWEEN $1 AND $2 AND topic=$3", rating_low,  rating_high, topic)
        else:
            r = await con.fetch("SELECT * FROM books WHERE weighted_rating BETWEEN $1 AND $2", rating_low,  rating_high)

        return r
    
@app.get('/api/top_books')
async def top_books():
    d = {}
    topics = ['ayurveda', 'siddha', 'unani']

    async with app.db.acquire() as con:
        for i in topics:
            d[i] = r = await con.fetch("SELECT * FROM books WHERE topic=$1 ORDER BY weighted_rating ASC LIMIT 3", i)
            # d[i] = [x.dict() for x in r]
            print(r)
            # print(d)
    
    return d

@app.get('/api/book/{book_id}')
async def get_books(book_id: int):
    async with app.db.acquire() as con:
        r = await con.fetch("SELECT * FROM books WHERE id=$1", book_id)
        print(type(r), r)
        return r
    
@app.post('/api/book')
async def post_books(request: Request):
    data = await request.json()
    async with app.db.acquire() as con:
        authors = await con.fetchval("SELECT (id, author_name) FROM authors")
        print(authors)
        for a in authors:
            if a.values[1] == data.author_name:
                author_id = a.values[0]
                r = await con.fetch("INSERT INTO books (title, author_id, book_description, topic, rating, weighted_rating) VALUES ($1, $2, $3, $4, $5, $6) RETURNING ID", data['title'], author_id, data['book_description'], data['topic'], 0,  0)
                return await con.fetch("SELECT * FROM books WHERE id=$1",  r)

@app.get("/api/books/{book_id}/reviews")
async def get_review(book_id: int):
    async with app.db.acquire() as con:
        r = await con.fetch("SELECT * FROM reviews WHERE book_id=$1", book_id)
        return r
    

@app.post("/api/books/{book_id}/reviews")
async def post_review(request: Request):
    data = await request.json()
    async with app.db.acquire() as con:
        user_type = await con.fetch("SELECT user_type FROM users WHERE user_id=$1", )
        weighted_rating = get_weighted_rating(data.rating, user_type)
        r = await con.fetch("INSERT INTO reviews (book_id, user_id, rating, weighted_rating, title, content) VALUES ($1, $2, $3, $4, $5, $6) RETURNING ID", data.book_id, data.user_id, data.rating, weighted_rating, data.title, data.content)
        return await con.fetch("SELECT * FROM reviews WHERE id=$1", r)

        

@app.get("/api/search_books/text")
async def search_text(data: str):
    data = data.lower()
    async with app.db.acquire() as con:
        books = await con.fetch("SELECT id, title FROM books")
    l =  []
    for book in books:

        if data in str(book[1]).lower():
            l.append(book[1])

    print(l)
    return l

@app.post('/api/upload/image')
async def search_image(request: Request):
    form = await request.form()
    l = []
    for i, j in form.items():
        print(i, type(j), j.file)

        ext = j.filename.split('.')[-1]

        contents = await j.read()

        now = datetime.now().timestamp()

        filename = str(int(now)) + str(random.randrange(1, 10000)) + '.' + ext

        pic_path = pics_dir / filename

        pic_path.touch()

        pic_path.write_bytes(contents)

        l.append(filename)
    
    return l[0]

@app.get('/api/ocr/{filename}')
async def ocr(filename: str, language: str):
    filename = filename.replace('\"', '')
    async with aiohttp.ClientSession() as ses:
        with open(pics_dir / filename) as f:
            payload = {'apikey': 'K81764681888957', 'language': language, filename: f}
            async with ses.post('https://api.ocr.space/parse/image', data=payload) as r:

                data = await r.text()
                print(data)


def get_weighted_rating(rating: float, user_type: str):
    if user_type == "student":
        return rating * 0.75
    else:
        return rating
