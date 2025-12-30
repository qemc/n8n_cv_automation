from starlette.responses import JSONResponse
from job_scraper import scrape_batch
from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from api.schemas import JobOffer

app = FastAPI()
@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    return JSONResponse(
        status_code = 422,
        content = {
            "error": "Invalid data format", 
            "details": str(exc)
        }
    )

@app.post('/')
async def read_root(request: JobOffer):

    urls = request.urls
    results = await scrape_batch(urls)
    return results
    
