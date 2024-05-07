

import fastapi
from fastapi.responses import PlainTextResponse,JSONResponse
from generate import generate_response
from huggingface_hub import login, logout
import os

router = fastapi.APIRouter()
HF_TOKEN=os.getenv("HF_TOKEN")
login(token=HF_TOKEN)


@router.get('/ping')
async def pingmethod():
    return JSONResponse(status_code=200, content={"status":"working"})


@router.post('/generate',response_class=JSONResponse)
async def generate(payload: dict):
    respstatus = {"status": "failure"}
    status_code = 500
    try:
        question = payload['question']
        context = payload['context']
        response=generate_response(question,context)
        resp_answer=response['answer']
        respstatus = {"status": "success","response":resp_answer}
        status_code = 200
        return JSONResponse(status_code=status_code, content=respstatus)
    except Exception as e:
        respstatus["error"] = str(e)
        return JSONResponse(status_code=status_code, content=respstatus)


