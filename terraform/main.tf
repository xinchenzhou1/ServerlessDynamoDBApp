provider "aws"{
    region = var.region_name
}

module "static_content_s3"{
    source = "./modules/S3"

    s3_bucket_name = var.s3_static_bucket_name
}

module "dynamodb_table"{
    source = "./modules/dynamodb"

    dynamodb_table_name = var.db_name
}


module "iam_policy_role"{
    source = "./modules/iam"
    iam_policy_name = var.iam_policy_name
    target_dynamodb_table = var.db_name
}

module "api_gateway"{
    source = "./modules/api_gateway"
    get_lambda_function = module.lambda_func.get_lambda_function_output
    delete_lambda_function = module.lambda_func.delete_lambda_function_output
    post_lambda_function = module.lambda_func.post_lambda_function_output
    put_lambda_function = module.lambda_func.put_lambda_function_output
    cognito_pool = module.cognito.cognito_user_pool_output
}
module "lambda_func"{
    source = "./modules/lambda"
    put_lambda_function_name = var.put_lambda_function_name
    post_lambda_function_name = var.post_lambda_function_name
    delete_lambda_function_name = var.delete_lambda_function_name
    get_lambda_function_name= var.get_lambda_function_name
    target_dynamodb_table = var.db_name
    lambda_role_arn = module.iam_policy_role.lambda-role.arn
}
module "cognito"{
    source = "./modules/cognito"
    username = var.test_username
    password = var.test_password
}