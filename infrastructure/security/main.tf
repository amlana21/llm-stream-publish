
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}



# Create an IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}


data "aws_iam_policy_document" "task_role_policy" {
  statement {
    actions   = ["logs:*","s3:*","dynamodb:*","cloudwatch:*","sns:*","lambda:*","secretsmanager:*","ds:*","ec2:*","ecr:*","ecs:*","iam:*","kms:*","sqs:*","ssm:*","sts:*","es:*"]
    effect   = "Allow"
    resources = ["*"]
  }

}



# ----role for lambda
data "aws_iam_policy_document" "custlambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cust_lambda_access" {
  statement {
    actions   = ["logs:*","s3:*","dynamodb:*","cloudwatch:*","sns:*","lambda:*","secretsmanager:*","ds:*","ec2:*","execute-api:*"]
    effect   = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "custlambdarole" {
    name               = "custlambdarole"
    assume_role_policy = data.aws_iam_policy_document.custlambda-assume-role-policy.json
    inline_policy {
        name   = "policy-867530231"
        policy = data.aws_iam_policy_document.cust_lambda_access.json
    }

}



# -----for apigw
data "aws_iam_policy_document" "api_gateway_policy" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "api_gateway_policy" {
  name   = "APIGatewayPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.api_gateway_policy.json
}

resource "aws_iam_role" "api_gateway_role" {
  name = "APIGatewayRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
   managed_policy_arns = [aws_iam_policy.api_gateway_policy.arn]
}

















