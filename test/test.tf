terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.39.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_lambda_function" "lambda-function" {
    function_name = "${var.tags}-lamda-function"
    role = aws_iam_role.lambda_role.arn
    runtime = "python3.9"
    filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")  
  handler = "index.test"
  depends_on = [
    aws_iam_role.lambda_role
  ]
  tags = {
    "Name" = "${var.tags}-lambda-function"
  }
}