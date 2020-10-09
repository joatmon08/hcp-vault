resource "aws_lambda_function" "function" {
  function_name = "${var.environment_name}-function"
  description   = "Demo Vault AWS Lambda extension"
  role          = aws_iam_role.lambda.arn
  filename      = "../demo-function/demo-function.zip"
  handler       = "main"
  runtime       = "provided.al2"
  layers        = ["arn:aws:lambda:${var.aws_region}:634166935893:layer:vault-lambda-extension:6"]

  environment {
    variables = {
      VAULT_ADDR           = var.hcp_vault_addr,
      VAULT_AUTH_ROLE      = aws_iam_role.lambda.name,
      VAULT_AUTH_PROVIDER  = "aws",
      VAULT_SECRET_PATH_DB = "database/creds/lambda-function",
      VAULT_SECRET_FILE_DB = "/tmp/vault_secret.json",
      VAULT_SECRET_PATH    = "secret/myapp/config",
      VAULT_NAMESPACE      = var.hcp_vault_namespace
      DATABASE_URL         = aws_db_instance.main.address
    }
  }
}
