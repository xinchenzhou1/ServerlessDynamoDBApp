# Create dynamodb access policies to the dynamodb table,
# attach the policy to the lambda function role:

# create sts:AssumeRole for lambda service
data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# create iam role for lambda function to use
resource "aws_iam_role" "iam_for_lambda" {
  name               = "target-dynamodb-full-access-role"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

# create dynamodb table full access policy document for dynamodb table
data "aws_iam_policy_document" "lambda_access_policy" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:*"]
    resources = ["arn:aws:dynamodb:*:*:table/${var.target_dynamodb_table}", "*"]
  }
}

# create dynamodb table access policy from policy document
resource "aws_iam_policy" "policy" {
  name        = "dynamodb-lambda-access-policy"
  description = "A policy allows full dynamodb access to the input dynamodb table specified"
  policy      = data.aws_iam_policy_document.lambda_access_policy.json
}

# attach policy to the role
resource "aws_iam_role_policy_attachment" "attach-role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}