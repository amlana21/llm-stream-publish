from fastapi import FastAPI,Response
import fastapi
from fastapi.responses import PlainTextResponse,JSONResponse
import os
import uvicorn

import os
import uvicorn

from app import router

api = fastapi.FastAPI()

def configure():
    configure_routing()

def configure_routing():
    api.include_router(router)

if __name__ == '__main__':
    configure()
    uvicorn.run("main:api", host="0.0.0.0", port=5001, reload=True)
else:
    configure()