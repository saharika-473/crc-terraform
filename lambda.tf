# data "aws_iam_policy_document" "ApiGatewayPolicy" {
#   statement {
#     effect = "Allow"
#     actions = ["lambda:InvokeFunction"]
#     resources = [ "${aws_api_gateway_rest_api.CloudResumeChallengeAPI.arn}/*/*" ]
#   }
# }



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
resource "aws_iam_policy" "CloudWatchPolicy" {
  name        = "${local.naming_convention}-CloudWatch-Logs-Policy"
  description = "IAM policy for CloudWatch Logs"
  policy      = data.aws_iam_policy_document.CloudWatchLogsPolicy.json
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogsPolicyAttach" {
  policy_arn = aws_iam_policy.CloudWatchPolicy.arn
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

    depends_on = [ aws_cloudwatch_log_group.LambdaLogs ]

    tags = var.tags

}

resource "aws_cloudwatch_log_group" "LambdaLogs" {
  name = "/aws/lambda/${local.naming_convention}-visit-counter"

  tags = var.tags
}
# resource "aws_lambda_permission" "api_gateway" {
#   action = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.CloudResumeChallenge.function_name
#   principal = "apigateway.amazonaws.com"
#   source_arn = "${aws_api_gateway_rest_api.CloudResumeChallengeAPI.arn}/*/*"
# }

# Use archive_file to create a zip file from the local source code directory
data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "./lambda_functions/visit_counter.py"
  output_path = "lambda_function_payload.zip"
}
