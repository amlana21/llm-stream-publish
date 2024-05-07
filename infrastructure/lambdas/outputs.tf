

output "llm_lambda_invoke_arn" {
  value =aws_lambda_function.invoke_llm_lambda.invoke_arn
  
}

output "connect_lambda_arn" {
  value = aws_lambda_function.connect_lambda.invoke_arn
}

output "disconnect_lambda_arn" {
  value = aws_lambda_function.disconnect_lambda.invoke_arn
}