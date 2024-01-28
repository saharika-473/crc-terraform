data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
  
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_lambda_function" "CloudResumeChallenge" {
    function_name = "${local.naming_convention}-visit-counter"
    architectures = [ "x86_64" ]
    runtime       = "python3.9"
    handler       = "lambda_function.lambda_handler"
    memory_size   = 128
    timeout       = 3

    # Use archive_file to create a zip file from your local source code
    source_code_hash = data.archive_file.lambda_code.output_base64sha256
    filename        = data.archive_file.lambda_code.output_path

    role = aws_iam_role.iam_for_lambda.arn

    tags = var.tags

}

# Use archive_file to create a zip file from the local source code directory
data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "./lambda_functions/visit_counter.py"
  output_path = "lambda_function_payload.zip"
}
