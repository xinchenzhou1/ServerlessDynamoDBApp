resource "aws_api_gateway_rest_api" "museumAPI" {
  name = "museumAPI"
  description = "museumRatingAPI"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

// API Resources
resource "aws_api_gateway_resource" "museumResource" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  parent_id = aws_api_gateway_rest_api.museumAPI.root_resource_id
  path_part = "museums"
}

// GET method
resource "aws_api_gateway_method" "getMuseumMethod" {
  rest_api_id   = aws_api_gateway_rest_api.museumAPI.id
  resource_id   = aws_api_gateway_resource.museumResource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.MuseumAppAuthorizer.id
}

resource "aws_api_gateway_integration" "get_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.getMuseumMethod.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = var.get_lambda_function.invoke_arn
  // The template instructs the API to take a value from a query parameter and 
  // transforms it into JSON, which the lambda functions can then consume via event object
  request_templates = {                 
    "application/json" = <<EOF
  {
  "MuseumType": "$input.params('MuseumType')"
  }
  EOF
  }
}
resource "aws_api_gateway_method_response" "get_lambda_method_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.getMuseumMethod.http_method
  status_code = "200"

  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

}

resource "aws_api_gateway_integration_response" "get_lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.getMuseumMethod.http_method
  status_code = aws_api_gateway_method_response.get_lambda_method_response.status_code


  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.getMuseumMethod,
    aws_api_gateway_integration.get_lambda_integration
  ]
}

// DELETE method
resource "aws_api_gateway_method" "deleteMuseumMethod" {
  rest_api_id   = aws_api_gateway_rest_api.museumAPI.id
  resource_id   = aws_api_gateway_resource.museumResource.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.MuseumAppAuthorizer.id
}

resource "aws_api_gateway_integration" "delete_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.deleteMuseumMethod.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = var.delete_lambda_function.invoke_arn
}
resource "aws_api_gateway_method_response" "delete_lambda_method_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.deleteMuseumMethod.http_method
  status_code = "200"

  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

}

resource "aws_api_gateway_integration_response" "delete_lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.deleteMuseumMethod.http_method
  status_code = aws_api_gateway_method_response.delete_lambda_method_response.status_code


  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.deleteMuseumMethod,
    aws_api_gateway_integration.delete_lambda_integration
  ]
}

// POST method
resource "aws_api_gateway_method" "postMuseumMethod" {
  rest_api_id   = aws_api_gateway_rest_api.museumAPI.id
  resource_id   = aws_api_gateway_resource.museumResource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.MuseumAppAuthorizer.id
}

resource "aws_api_gateway_integration" "post_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.postMuseumMethod.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = var.post_lambda_function.invoke_arn
}
resource "aws_api_gateway_method_response" "post_lambda_method_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.postMuseumMethod.http_method
  status_code = "200"

  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

}

resource "aws_api_gateway_integration_response" "post_lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.postMuseumMethod.http_method
  status_code = aws_api_gateway_method_response.post_lambda_method_response.status_code


  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.postMuseumMethod,
    aws_api_gateway_integration.post_lambda_integration
  ]
}

// PUT method
resource "aws_api_gateway_method" "putMuseumMethod" {
  rest_api_id   = aws_api_gateway_rest_api.museumAPI.id
  resource_id   = aws_api_gateway_resource.museumResource.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.MuseumAppAuthorizer.id
}

resource "aws_api_gateway_integration" "put_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.putMuseumMethod.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = var.put_lambda_function.invoke_arn
}
resource "aws_api_gateway_method_response" "put_lambda_method_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.putMuseumMethod.http_method
  status_code = "200"

  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

}

resource "aws_api_gateway_integration_response" "put_lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.putMuseumMethod.http_method
  status_code = aws_api_gateway_method_response.put_lambda_method_response.status_code


  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.putMuseumMethod,
    aws_api_gateway_integration.put_lambda_integration
  ]
}

// Options for CORS
resource "aws_api_gateway_method" "options" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = "OPTIONS"
  #   authorization = "NONE"
  authorization = "NONE"

}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.museumAPI.id
  resource_id             = aws_api_gateway_resource.museumResource.id
  http_method             = aws_api_gateway_method.options.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}
resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  resource_id = aws_api_gateway_resource.museumResource.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options_integration,
  ]
}


resource "aws_lambda_permission" "lambda_get_permission" {
  statement_id  = "AllowGETmuseumAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.museumAPI.execution_arn}/*"
}
resource "aws_lambda_permission" "lambda_delete_permission" {
  statement_id  = "AllowDELETEmuseumAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.delete_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.museumAPI.execution_arn}/*"
}
resource "aws_lambda_permission" "lambda_post_permission" {
  statement_id  = "AllowPOSTmuseumAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.post_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.museumAPI.execution_arn}/*"
}
resource "aws_lambda_permission" "lambda_put_permission" {
  statement_id  = "AllowPUTmuseumAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.put_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.museumAPI.execution_arn}/*"
}

// deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.get_lambda_integration,
    aws_api_gateway_integration.delete_lambda_integration,
    aws_api_gateway_integration.post_lambda_integration,
    aws_api_gateway_integration.put_lambda_integration,
    aws_api_gateway_integration.options_integration, 
    aws_api_gateway_integration_response.get_lambda_integration_response,
    aws_api_gateway_integration_response.delete_lambda_integration_response,
    aws_api_gateway_integration_response.options_integration_response,
    aws_api_gateway_integration_response.post_lambda_integration_response,
    aws_api_gateway_integration_response.put_lambda_integration_response
  ]

  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.museumAPI.id
  stage_name    = "dev"
}

// Add Cognito Authorizer

resource "aws_api_gateway_authorizer" "MuseumAppAuthorizer" {
  name = "museumAppAuthorizer"
  rest_api_id = aws_api_gateway_rest_api.museumAPI.id
  type = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_pool.arn]
}
