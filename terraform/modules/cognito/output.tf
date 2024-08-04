output "cognito_user_pool_output"{
    value = aws_cognito_user_pool.MuseumAppPool
}
output "cognito_user_pool_client_output"{
    value = aws_cognito_user_pool_client.client
}