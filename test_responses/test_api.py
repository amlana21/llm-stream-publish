from websocket import WebSocketApp
import ssl
import json
import time


# question and context list of 3 combinations
questions_list=[
    {
    "question":"What are the frameworks backing transformers?",
    "context":"Transformers is backed by the three most popular deep learning libraries — Jax, PyTorch and TensorFlow — with a seamless integration between them. It's straightforward to train your models with one before loading them for inference with the other."
},

{
    "question":"What are the pillars for well architected framework?",
    "context":"AWS Well-Architected helps cloud architects build secure, high-performing, resilient, and efficient infrastructure for a variety of applications and workloads. Built around six pillars—operational excellence, security, reliability, performance efficiency, cost optimization, and sustainability—AWS Well-Architected provides a consistent approach for customers and partners to evaluate architectures and implement scalable designs."
},

{
    "question":"What is the foundation for ChatGPT?",
    "context":"ChatGPT stands for chatbot generative pre-trained transformer. The chatbot’s foundation is the GPT large language model (LLM), a computer algorithm that processes natural language inputs and predicts the next word based on what it’s already seen. Then it predicts the next word, and the next word, and so on until its answer is complete."
}]



def on_message(ws, message):
    if message == "End of answer":
        pass
    else:
        print("Received answer:", message)

def on_error(ws, error):
    print("WebSocket error:", error)

def on_close(ws, a, b):
    print("WebSocket connection closed")

def on_open(ws):
    print("WebSocket connection opened")
    # Send a request after the connection is opened
    for i in range(3):
        request = questions_list[i]
        print(f'Question: {request["question"]}')
        ws.send(json.dumps(request))
        time.sleep(3)

if __name__ == "__main__":
    # Specify your WebSocket API Gateway endpoint URL
    websocket_url = "<api_url>"

    # Create a WebSocket connection
    ws = WebSocketApp(websocket_url,
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)
    ws.on_open = on_open
    ws.run_forever()