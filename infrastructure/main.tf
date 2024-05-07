terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.11.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }

   cloud {
    organization = ""

    workspaces {
      name = ""
    }
  }  

}

provider "aws" {
  region = "us-east-1"
}


module "security_module" {
  source = "./security"
}

module "networking_module" {
  source = "./networking"
}

module "ecs_module" {
  source = "./ecs"
  task_role_arn = module.security_module.task_execution_role_arn
  subnet_ids = module.networking_module.subnet_ids
  task_sg_id = module.networking_module.task_sg_id
  target_grp_arn = module.networking_module.tg_arn
  
}

module "lambda_module" {
  source = "./lambdas"
  lambda_role_arn = module.security_module.lambda_role_arn
  api_dns = module.networking_module.lb_dns
  api_url=module.apigw_module.api_endpoint
}

module "apigw_module" {
  source = "./apigw"
  connect_lambda_arn = module.lambda_module.connect_lambda_arn
  disconnect_lambda_arn = module.lambda_module.disconnect_lambda_arn
  invoke_llm_lambda_arn=module.lambda_module.llm_lambda_invoke_arn
  apigw_role_arn=module.security_module.apigw_role_arn
  llm_lambda_invoke_arn=module.lambda_module.llm_lambda_invoke_arn
}