resource "aws_apigatewayv2_api" "socketAPI" {
  name                     = "socketAPI"
  protocol_type            = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_integration" "ConnectInteg" {
  api_id           = aws_apigatewayv2_api.socketAPI.id
  integration_type = "AWS_PROXY"
  credentials_arn  = var.apigw_role_arn
  integration_uri  = var.llm_lambda_invoke_arn
}

resource "aws_apigatewayv2_integration" "EstablishConnectInteg" {
  api_id           = aws_apigatewayv2_api.socketAPI.id
  integration_type = "AWS_PROXY"
  credentials_arn  = var.apigw_role_arn
  integration_uri  = var.connect_lambda_arn
}

resource "aws_apigatewayv2_integration" "DisConnectInteg" {
  api_id           = aws_apigatewayv2_api.socketAPI.id
  integration_type = "AWS_PROXY"
  credentials_arn  = var.apigw_role_arn
  integration_uri  = var.disconnect_lambda_arn
}

resource "aws_apigatewayv2_route" "ConnectRoute" {
  api_id    = aws_apigatewayv2_api.socketAPI.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.EstablishConnectInteg.id}"
}

resource "aws_apigatewayv2_route" "api_default_route" {
  api_id    = aws_apigatewayv2_api.socketAPI.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.ConnectInteg.id}"
}
resource "aws_apigatewayv2_route_response" "api_default_route_response" {
  api_id             = aws_apigatewayv2_api.socketAPI.id
  route_id           = aws_apigatewayv2_route.api_default_route.id
  route_response_key = "$default"
}

resource "aws_apigatewayv2_route" "api_disconnect_route" {
  api_id    = aws_apigatewayv2_api.socketAPI.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.DisConnectInteg.id}"
}

resource "aws_apigatewayv2_route" "api_call_route" {
  api_id    = aws_apigatewayv2_api.socketAPI.id
  route_key = "generate"
  target    = "integrations/${aws_apigatewayv2_integration.ConnectInteg.id}"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.socketAPI.id
  name        = "dev"
  auto_deploy = true
}