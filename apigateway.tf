resource "aws_api_gateway_rest_api" "CloudResumeChallengeAPI" {
  name        = "${local.naming_convention}-API"
  description = "API for Cloud Resume Challenge"
}

resource "aws_api_gateway_resource" "countVisitor" {
  rest_api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  parent_id   = aws_api_gateway_rest_api.CloudResumeChallengeAPI.root_resource_id
  path_part   = "countVisitor"
}

resource "aws_api_gateway_method" "GETcountVisitor" {
  rest_api_id   = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  resource_id   = aws_api_gateway_resource.countVisitor.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "example" {
  rest_api_id             = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  resource_id             = aws_api_gateway_resource.countVisitor.id
  http_method             = aws_api_gateway_method.GETcountVisitor.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"  # Adjust based on your Lambda function's requirements
  uri                     = aws_lambda_function.CloudResumeChallenge.invoke_arn
}