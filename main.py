from starlette.responses import JSONResponse
from job_scraper.engine import scrape_offer 
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

    url = request.url
    scrape_result = scrape_offer(url)

    return scrape_result
    
