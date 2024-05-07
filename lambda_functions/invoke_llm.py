import json
import os
import requests
import boto3

api_url=os.getenv("API_URL")

def lambda_handler(event, context):
    body = json.loads(event["body"])
    qry=body["question"]
    contxt=body["context"]
    connectionId = event["requestContext"]["connectionId"]
    resp = requests.post(api_url, json={"question": qry, "context": contxt})
    print(resp.text)
    answer_resp=json.loads(resp.text)['response']

    # websocket reply
    gatewayapi = boto3.client("apigatewaymanagementapi", endpoint_url=os.getenv("WS_URL"),region_name='us-east-1')
    params = {
            "Data":answer_resp,
            "ConnectionId": connectionId
        }
    response = gatewayapi.post_to_connection(**params)
    print(response)
    

    return {
        'statusCode': 200,
        'body': 'End of answer'
    }
