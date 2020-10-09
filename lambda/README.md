# Vault Lambda extension Quick Start

This quick start folder has terraform and an example function for creating all the
infrastructure you need to run a demo of the Vault Lambda extension. By default,
the infrastructure is created in `us-east-1`. See [variables.tf](terraform/variables.tf)
for the available variables, including region and instance types.

The terraform will create:

* An EC2 instance with a configured Vault server
* A new SSH key pair used to SSH into the instance
* IAM role for the Lambda to run as, configured for AWS IAM auth on Vault
* An RDS database for which Vault can manage dynamic credentials
* A Lambda function which requests database credentials from the extension and then uses them to list users on the database

**NB: This demo will create real infrastructure in AWS with an associated
cost. Make sure you tear down the infrastructure once you are finished with
the demo.**

**NB: This is not a production-ready deployment, and is for demonstration
purposes only.**

## Prerequisites

* `bash`, `zip`
* Golang
* Terraform
* AWS account with access key ID and secret access key
* AWS CLI v2 configured with the same account

## Usage

```bash
./build.sh
cd terraform

export AWS_ACCESS_KEY_ID = "<YOUR_AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY = "<YOUR_AWS_SECRET_ACCESS_KEY>"
terraform init
terraform apply

# Then run the `aws lambda invoke` command from the terraform output

# Remember to clean up the billed resources once you're finished
terraform destroy
```

## Credit

Adapted from AWS KMS guides in the [vault-guides](https://github.com/hashicorp/vault-guides) repo.
Specifically, mostly from [this guide](https://learn.hashicorp.com/tutorials/vault/agent-aws).

## Additional instructions

```shell
$ aws lambda update-function-configuration --function-name hcp-vault-lambda-extension-demo-function \
--layers arn:aws:lambda:us-west-2:634166935893:layer:vault-lambda-extension:6
{
    "FunctionName": "hcp-vault-lambda-extension-demo-function",
    "FunctionArn": "arn:aws:lambda:us-west-2:REDACTED:function:hcp-vault-lambda-extension-demo-function",
    "Runtime": "provided.al2",
    "Role": "arn:aws:iam::REDACTED:role/hcp-vault-lambda-extension-demo-lambda-role",
    "Handler": "main",
    "CodeSize": 3084547,
    "Description": "Demo Vault AWS Lambda extension",
    "Timeout": 3,
    "MemorySize": 128,
    "LastModified": "2020-10-09T20:12:08.299+0000",
    "CodeSha256": "tQMPHtOI7EqS1l8n51VjWdB7ZIqzaqTtAnFRMidoLco=",
    "Version": "$LATEST",
    "Environment": {
        "Variables": {
            "VAULT_AUTH_PROVIDER": "aws",
            "VAULT_SECRET_PATH": "secret/myapp/config",
            "DATABASE_URL": "terraform-20201009195627953600000001.cho1mmdxhp1z.us-west-2.rds.amazonaws.com",
            "VAULT_ADDR": "https://vault-cluster.vault.11eaeb92-853e-2d98-8405-0242ac110009.aws.hashicorp.cloud:8200",
            "VAULT_NAMESPACE": "admin",
            "VAULT_SECRET_FILE_DB": "/tmp/vault_secret.json",
            "VAULT_SECRET_PATH_DB": "database/creds/lambda-function",
            "VAULT_AUTH_ROLE": "hcp-vault-lambda-extension-demo-lambda-role"
        }
    },
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "RevisionId": "3a11e989-24e0-4442-acd6-d8b3760aabcf",
    "Layers": [
        {
            "Arn": "arn:aws:lambda:us-west-2:634166935893:layer:vault-lambda-extension:6",
            "CodeSize": 2960488
        }
    ],
    "State": "Active",
    "LastUpdateStatus": "Successful"
}
```

```shell
$ cat <<EOF > lambda.hcl
path "database/creds/lambda-function" {
  capabilities = ["read"]
}
EOF
```

```shell
$ vault policy write lambda ./lambda.hcl
```


Configuring AWS Auth method....

```shell
$ vault auth enable aws

$ vault write -force auth/aws/config/client

$ vault write auth/aws/config/sts/$(terraform output account_id) sts_role=$(terraform output bound_iam_principal_arn)
Success! Data written to: auth/aws/config/sts/$(terraform output account_id)

$ vault write auth/aws/role/$(terraform output lambda_role) \
    auth_type=iam \
    bound_iam_principal_arn="$(terraform output bound_iam_principal_arn)" \
    policies="lambda" \
    ttl=1h
Error writing data to auth/aws/role/hcp-vault-lambda-extension-demo-lambda-role: Error making API request.
URL: PUT https://vault-cluster.vault.**********.aws.hashicorp.cloud:8200/v1/auth/aws/role/hcp-vault-lambda-extension-demo-lambda-role
Code: 400. Errors:
* unable to resolve ARN "arn:aws:iam::REDACTED:role/hcp-vault-lambda-extension-demo-lambda-role" to internal ID: AccessDenied: User: arn:aws:sts::468001993716:assumed-role/HCP-Vault-11eb0976-d03c-135a-bde9-0242ac110008-VaultNode/i-077de012faecd3c8b is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::REDACTED:role/hcp-vault-lambda-extension-demo-lambda-role
        status code: 403, request id: 4f58a2f2-14b6-47cc-8b68-4ccb3f48c5f3
```