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

resource "aws_api_gateway_integration" "Integration" {
  rest_api_id             = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  resource_id             = aws_api_gateway_resource.countVisitor.id
  http_method             = aws_api_gateway_method.GETcountVisitor.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "GET"  # Adjust based on your Lambda function's requirements
  uri                     = aws_lambda_function.CloudResumeChallenge.invoke_arn
}

resource "aws_lambda_permission" "LambdaInvoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CloudResumeChallenge.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.CloudResumeChallengeAPI.arn}/*/*"
}

resource "aws_api_gateway_deployment" "stage" {
  depends_on = [aws_api_gateway_integration.Integration]

  rest_api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  stage_name  = "${var.environment_acronym}" 
}