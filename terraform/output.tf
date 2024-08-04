output "api_gateway_endpoint"{
    value = module.api_gateway.api_gateway_deployment_output.invoke_url
}

output "s3_url"{
    value = module.static_content_s3.s3_web_hosting_output.website_endpoint
}