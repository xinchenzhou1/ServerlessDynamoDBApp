output "api_gateway_endpoint"{
    value = module.api_gateway.api_gateway_deployment_output.invoke_url
}

output "s3_url"{
    value = module.static_content_s3.s3_web_hosting_output.website_endpoint
}

output "cognito_user_pool_id"{
    value = module.cognito.cognito_user_pool_output.id
}

output "cognito_user_pool_client_id"{
    value = module.cognito.cognito_user_pool_client_output.id
}
