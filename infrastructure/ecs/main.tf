data "aws_caller_identity" "current" {}


resource "aws_ecr_repository" "appimagerepo" {
  name                 = "<repo_name>"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecs_cluster" "app_cluster" {
  name = "app-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


# --------------------app service and task definition--------------------
resource "aws_cloudwatch_log_group" "app-logs" {
  name = "/app-logs"  

  retention_in_days = 30  
}

resource "aws_ecs_task_definition" "app_task_def" {
  family                   = "app-task-def"
  network_mode             = "awsvpc"
  execution_role_arn       = var.task_role_arn
  task_role_arn = var.task_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096

  container_definitions = <<DEFINITION
[
  {
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/<repo>:latest",
    "cpu": 2048,
    "memory": 4096,
    "name": "app-task-container",
    "networkMode": "awsvpc",
    "environment": [
      {
        "name": "HF_TOKEN",
        "value": ""
      },
      {
        "name": "MODEL_NAME",
        "value": "<HF Model name>"
      }
    ],
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/app-logs",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "app_service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task_def.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    assign_public_ip = false
    security_groups = [var.task_sg_id]
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_grp_arn
    container_name   = "app-task-container"
    container_port   = 5000
  }

  health_check_grace_period_seconds = 60
  enable_ecs_managed_tags = false
}