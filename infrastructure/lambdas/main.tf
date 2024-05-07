

resource "aws_lambda_function" "connect_lambda" {
  filename         = "${path.module}/connect_lambda.py.zip"
  function_name    = "connect_lambda"
  role             = var.lambda_role_arn
  handler          = "connect_lambda.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/connect_lambda.py.zip")
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 128
  publish          = true
  tags = {
    Name = "connect_lambda"
    terraform = true
  }
}


resource "aws_lambda_function" "disconnect_lambda" {
  filename         = "${path.module}/disconnect_lambda.py.zip"
  function_name    = "disconnect_lambda"
  role             = var.lambda_role_arn
  handler          = "disconnect_lambda.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/disconnect_lambda.py.zip")
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 128
  publish          = true
  tags = {
    Name = "disconnect_lambda"
    terraform = true
  }
}


resource "aws_lambda_function" "invoke_llm_lambda" {
  filename         = "${path.module}/invoke_llm.py.zip"
  function_name    = "invoke_llm"
  role             = var.lambda_role_arn
  handler          = "invoke_llm.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/invoke_llm.py.zip")
  runtime          = "python3.9"
  timeout          = 900
  memory_size      = 128
  publish          = true
  layers = [aws_lambda_layer_version.llm_layer.arn]
  environment {
    variables = {
      API_URL = "http://${var.api_dns}/generate"
      WS_URL = var.api_url
    }
  }
  tags = {
    Name = "invoke_llm"
    terraform = true
  }
}



# add a layer
resource "aws_lambda_layer_version" "llm_layer" {
  layer_name = "llm_layer"
  compatible_runtimes = ["python3.9"]
  source_code_hash = filebase64sha256("${path.module}/llm-lambda-layer.zip")
  filename = "${path.module}/llm-lambda-layer.zip"
  description = "LLM Lambda Layer"
  license_info = "MIT"
}