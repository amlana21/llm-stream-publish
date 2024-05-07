from transformers import pipeline
import os
from huggingface_hub import login, logout

model_name=os.getenv("MODEL_NAME")

question_answerer = pipeline("question-answering", model=model_name,framework="tf")

def generate_response(question: str, context: str):
    resp=question_answerer(question=question, context=context)    
    return resp