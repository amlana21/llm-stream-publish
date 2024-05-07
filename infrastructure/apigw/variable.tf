

variable "connect_lambda_arn" {
    description = "The ARN of the connect lambda function"
    default = ""
}

variable "disconnect_lambda_arn" {
    description = "The ARN of the disconnect lambda function"
    default = ""
}

variable "invoke_llm_lambda_arn" {
    description = "The ARN of the invoke_llm lambda function"
    default = ""
}

variable "apigw_role_arn" {
    description = "The ARN of the IAM role to use for the API Gateway"
    default = ""
}

variable "llm_lambda_invoke_arn" {
    description = "The ARN of the invoke_llm lambda function"
    default = ""
}