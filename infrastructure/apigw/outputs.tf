output "api_endpoint" {
  value = "https://${aws_apigatewayv2_api.socketAPI.id}.execute-api.us-east-1.amazonaws.com/dev"
}