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
  authorization = "None"
  api_key_required = true
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
  source_arn = aws_api_gateway_deployment.deployment.execution_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  description = "API deployment triggered by Terraform"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  stage_name  = "${var.environment_acronym}" 
}


resource "aws_api_gateway_usage_plan" "usage_plan" {
  name        = "${local.naming_convention}-UsagePlan"  # Follow naming convention
  description = "Usage plan for ${local.naming_convention} API"

  api_stages {
    api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
    stage  = aws_api_gateway_stage.stage.stage_name
  }

  quota_settings {
    limit      = 1000
    offset     = 2
    period     = "MONTH"
  }

  throttle_settings {
    burst_limit = 200
    rate_limit  = 100
  }
}

resource "aws_api_gateway_api_key" "example_api_key" {
  name    = "${local.naming_convention}-APIKey"  # Follow naming convention
  enabled = true
}


resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = aws_api_gateway_api_key.example_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}
