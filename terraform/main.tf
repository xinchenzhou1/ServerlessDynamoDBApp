provider "aws"{
    region = var.region_name
}

# S3 module for static website hostings
module "static_content_s3"{
    source = "./modules/S3"

    s3_bucket_name = var.s3_static_bucket_name
}
# Dynamodb module for museum data storage
module "dynamodb_table"{
    source = "./modules/dynamodb"

    dynamodb_table_name = var.db_name
}

# IAM role based policy module for lambda functions to access dynamodb Table
module "iam_policy_role"{
    source = "./modules/iam"
    iam_policy_name = var.iam_policy_name
    target_dynamodb_table = var.db_name
}

# API Gateway module to proxy the lambda functions
module "api_gateway"{
    source = "./modules/api_gateway"
    get_lambda_function = module.lambda_func.get_lambda_function_output
    delete_lambda_function = module.lambda_func.delete_lambda_function_output
    post_lambda_function = module.lambda_func.post_lambda_function_output
    put_lambda_function = module.lambda_func.put_lambda_function_output
    cognito_pool = module.cognito.cognito_user_pool_output
    api_gateway_stage_name = var.api_gateway_stage_name
}

# Lambda functions to perform CRUD operations against dynamodb table
module "lambda_func"{
    source = "./modules/lambda"
    put_lambda_function_name = var.put_lambda_function_name
    post_lambda_function_name = var.post_lambda_function_name
    delete_lambda_function_name = var.delete_lambda_function_name
    get_lambda_function_name= var.get_lambda_function_name
    target_dynamodb_table = var.db_name
    lambda_role_arn = module.iam_policy_role.lambda-role.arn
}

# Cognito user pool module to control user access to API Gateway
module "cognito"{
    source = "./modules/cognito"
    username = var.test_username
    password = var.test_password
}

# ACM to provision and manage SSL/TLS certificates with AWS services
module "ACM"{
    source = "./modules/ACM"
    route53_root_domain = var.root_domain_name
    sub_alt_name = var.sub_domain_name
}

# Cloudfront module to do CDN for S3 website hosting
module "cloudfront"{
    source = "./modules/cloudfront"
    acm_cert = module.ACM.acm_app_cert_output
    s3_web_hosting_url = module.static_content_s3.s3_web_hosting_output
    s3_bucket_info = module.static_content_s3.s3_bucket_output
    root_domain_name = var.root_domain_name
    sub_domain_name = var.sub_domain_name
}
