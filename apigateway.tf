resource "aws_api_gateway_rest_api" "CloudResumeChallengeAPI" {
  name        = "${local.naming_convention}-API"
  description = "API for Cloud Resume Challenge"

  tags = var.tags
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
  integration_http_method = "POST"  # Adjust based on your Lambda function's requirements
  uri                     = aws_lambda_function.CloudResumeChallenge.invoke_arn
}

resource "aws_lambda_permission" "LambdaInvoke" {
  statement_id  = "AllowAPIGatewayInvok"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CloudResumeChallenge.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = aws_api_gateway_deployment.stage.execution_arn
}

resource "aws_api_gateway_deployment" "stage" {
  depends_on = [aws_api_gateway_integration.Integration]

  rest_api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  stage_name  = "${var.environment_acronym}" 
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  resource_id = aws_api_gateway_resource.countVisitor.id
  http_method = aws_api_gateway_method.GETcountVisitor.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  resource_id = aws_api_gateway_resource.countVisitor.id
  http_method = aws_api_gateway_method.GETcountVisitor.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

}

# resource "aws_apigatewayv2_domain_name" "APIGatewayCustomDomain" {
#   domain_name = "rahulpatel.cloud"

#   domain_name_configuration {
#     certificate_arn = aws_acm_certificate.MyCertificate.arn
#     endpoint_type   = "REGIONAL"
#     security_policy = "TLS_1_2"
#   }
# }

# resource "aws_api_gateway_base_path_mapping" "APIGatewayCustomDomainMapping" {
#   api_id      = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
#   stage_name  = aws_api_gateway_deployment.stage.stage_name
#   domain_name = aws_apigatewayv2_domain_name.APIGatewayCustomDomain.domain_name
# }