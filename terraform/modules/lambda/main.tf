# Configure and deploy lambda function:
resource "aws_lambda_function" "addMuseum" {
  filename      = "../src/lambda/addMuseum/lambda_function.zip"
  function_name = var.post_lambda_function_name
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  timeout = "30"
  runtime = "python3.12"

  environment {
    variables = {
      tablename = var.target_dynamodb_table
    }
  }
}
resource "aws_lambda_function" "deleteMuseum" {
  filename      = "../src/lambda/deleteMuseum/lambda_function.zip"
  function_name = var.delete_lambda_function_name
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  timeout = "30"
  runtime = "python3.12"

  environment {
    variables = {
      tablename = var.target_dynamodb_table
    }
  }
}
resource "aws_lambda_function" "showMuseum" {
  filename      = "../src/lambda/showMuseum/lambda_function.zip"
  function_name = var.get_lambda_function_name
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  timeout = "30"
  runtime = "python3.12"

  environment {
    variables = {
      tablename = var.target_dynamodb_table
    }
  }
}
resource "aws_lambda_function" "updateMuseum" {
  filename      = "../src/lambda/updateMuseum/lambda_function.zip"
  function_name = var.put_lambda_function_name
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  timeout = "30"
  runtime = "python3.12"

  environment {
    variables = {
      tablename = var.target_dynamodb_table
    }
  }
}