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
# #   allowed_oauth_scopes = ["aws.cognito.signin.user.admin","email", "openid", "profile"]
# #   allowed_oauth_flows = ["implicit", "code"]
#   explicit_auth_flows = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers = ["COGNITO"]

  user_pool_id = aws_cognito_user_pool.MuseumAppPool.id
#   callback_urls = ["https://example.com"]
}

resource "aws_cognito_user" "test_user" {
  user_pool_id = aws_cognito_user_pool.MuseumAppPool.id
  username = var.username
  password = var.password
}