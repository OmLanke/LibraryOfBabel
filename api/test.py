import aiohttp
import asyncio

async def main():
    payload = {'url': 'https://media.discordapp.net/attachments/1154123075240075318/1155143989754863616/nzv174.png?width=632&height=998',
                'isOverlayRequired': False,
                'apikey': 'K81764681888957',
                'language': 'hin',
                'OCREngine': 3
                }
    async with aiohttp.ClientSession() as ses:
        async with ses.post('https://api.ocr.space/parse/image', data=payload) as r:
            rs = await r.json()
            print(rs)
        

asyncio.run(main())