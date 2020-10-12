output "bound_iam_principal_arn" {
  value = aws_iam_role.lambda.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.function.function_name
}

output "lambda_role" {
  value = aws_iam_role.lambda.name
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}