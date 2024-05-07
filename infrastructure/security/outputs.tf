output "task_execution_role_arn" {
    value = aws_iam_role.ecs_task_execution_role.arn
}


output "lambda_role_arn" {
    value = "${aws_iam_role.custlambdarole.arn}"
}

output "apigw_role_arn" {
    value = "${aws_iam_role.api_gateway_role.arn}"
}