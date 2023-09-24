from pydantic import BaseModel
from enum import Enum

class BookTopic(Enum):
    AYURVEDA = "ayurveda"
    SIDDHA = "siddha"
    UNANI = "unani"


class InsertBook(BaseModel):
    user_id: int
    isbn: int = None
    title: str
    subtitle: str = None
    book_description: str
    topic: BookTopic

class PostReview(BaseModel):
    book_id: int
    user_id: int
    rating: float
    title: str
    content: str

