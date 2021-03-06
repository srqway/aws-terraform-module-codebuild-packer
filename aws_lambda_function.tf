resource "aws_lambda_function" "ami_encryption_lambda" {
  count         = var.encrypt_ami ? 1 : 0
  filename      = data.archive_file.ami_encryption[0].output_path
  description   = "Responsible for creating AMI with encrypted root volume."
  function_name = "${upper(var.environment)}-AMI-ENCRYPTION-FUNCTION"

  role             = aws_iam_role.ami_encrypt_lambda[0].arn
  handler          = "ami_encryption.lambda_handler"
  runtime          = "python3.6"
  timeout          = 180
  source_code_hash = data.archive_file.ami_encryption[0].output_base64sha256

  environment {
    variables = {
      KMS_ENABLED = var.encrypt_ami
      KMS_KEY     = var.kms_key_arn
    }
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = "${var.environment}-AMI-ENCRYPTION-LAMBDA"
    },
  )
}

