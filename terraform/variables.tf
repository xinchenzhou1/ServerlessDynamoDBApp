variable region_name{
    type = string
    description = "aws resources region"
    default = "us-east-1"
}

variable s3_static_bucket_name{
    type = string
    description = "name of the s3 bucket for static website hosting"
    default = "mymuseum-site-test-demo"
}

variable db_name{
    type = string
    description = "name of the dynamodb table"
    default = "mymuseum-dynamodb-table-demo"
}
variable get_lambda_function_name{
    type = string
    description = "name of the get method lambda function"
    default = "getMuseum"
}
variable post_lambda_function_name{
    type = string
    description = "name of the post method lambda function"
    default = "addMuseum"
}
variable put_lambda_function_name{
    type = string
    description = "name of the put method lambda function"
    default = "updateMuseum"
}
variable delete_lambda_function_name{
    type = string
    description = "name of the delete method lambda function"
    default = "deleteMuseum"
}

variable iam_policy_name{
    type = string
    description = "name of the iam policy for lambda functions"
    default = ""
}

variable api_gateway_stage_name{
    type = string
    description = "name of the API gateway stage name"
    default = "test"
}

variable test_username{
    type = string
    description = "name of the cognito user name for testing"
    default = "testuser"
}

variable test_password{
    type = string
    description = "name of the cognito user password for testing"
    default = "testuser"
}

variable root_domain_name{
    type = string
    description = "name of the registered domain for web hosting, e.g. example.com"
    default = ""
}
variable sub_domain_name{
    type = string
    description = "name of the subject alternative name of the domain e.g. www.example.com"
    default = ""
}