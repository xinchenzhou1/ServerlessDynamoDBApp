resource "aws_cognito_user_pool" "MuseumAppPool" {
  name = "MuseumAppPool"

  alias_attributes = ["preferred_username"]
  password_policy {
    minimum_length    = 8
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  mfa_configuration = "OFF"

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "museumAppClient"
  allowed_oauth_flows_user_pool_client = false
  generate_secret = false
  supported_identity_providers = ["COGNITO"]

  user_pool_id = aws_cognito_user_pool.MuseumAppPool.id
}

resource "aws_cognito_user" "test_user" {
  user_pool_id = aws_cognito_user_pool.MuseumAppPool.id
  username = var.username
  password = var.password
}