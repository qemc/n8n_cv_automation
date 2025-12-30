from typing import List
from pydantic import BaseModel

class JobOffer(BaseModel):
    urls: List[str]