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

data "aws_iam_policy_document" "ApiGatewayPolicy" {
  statement {
    effect = "Allow"
    actions = ["lambda:InvokeFunction"]
    resources = [ aws_lambda_function.CloudResumeChallenge.arn ]
    principals {
      type = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "DynamoDBPolicy" {
    statement {
    effect = "Allow"
    actions = [ "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem", ]
    resources = [ aws_dynamodb_table.visit_counter.arn ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${local.naming_convention}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "DynamoDBPolicy" {
  name        = "${local.naming_convention}-DynamoDB-Access-Policy"
  description = "IAM policy for DynamoDB"
  policy      = data.aws_iam_policy_document.DynamoDBPolicy.json
}

resource "aws_iam_role_policy_attachment" "DynamoDBPolicyAttach" {
  policy_arn = aws_iam_policy.DynamoDBPolicy.arn
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_iam_policy" "ApiGatewayPolicy" {
  name        = "${local.naming_convention}-APIGateway-Access-Policy"
  description = "IAM policy for API Gateway"
  policy      = data.aws_iam_policy_document.ApiGatewayPolicy.json
}

resource "aws_iam_role_policy_attachment" "ApiGatewayPolicyAttach" {
  policy_arn = aws_iam_policy.ApiGatewayPolicy.arn
  role       = aws_iam_role.iam_for_lambda.name
}


resource "aws_lambda_function" "CloudResumeChallenge" {
    function_name = "${local.naming_convention}-visit-counter"
    architectures = [ "x86_64" ]
    runtime       = "python3.9"
    handler       = "visit_counter.lambda_handler"
    memory_size   = 128
    timeout       = 3

    environment {
      variables = {
        "environment_acronym" = var.environment_acronym 
      }
    }

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
