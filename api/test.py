import asyncpg
import asyncio

# async def main():
#     payload = {'url': 'https://media.discordapp.net/attachments/1154123075240075318/1155143989754863616/nzv174.png?width=632&height=998',
#                 'isOverlayRequired': False,
#                 'apikey': 'K81764681888957',
#                 'language': 'hin',
#                 'OCREngine': 3
#                 }
#     async with aiohttp.ClientSession() as ses:
#         async with ses.post('https://api.ocr.space/parse/image', data=payload) as r:
#             rs = await r.json()
#             print(rs)

async def main():
    con = await asyncpg.connect("postgresql://postgres:babel87775@100.65.182.43:5432/babel")
    for i in range(9):
        for j in range(4):
            r = await con.fetchvalue("SELECT user_type FROM users WHERE user_id=$1", j)
            await con.execute("INSERT INTO reviews (user_id, book_id, rating, )")

        

asyncio.run(main())