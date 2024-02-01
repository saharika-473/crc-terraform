resource "aws_api_gateway_rest_api" "CloudResumeChallengeAPI" {
  name        = "${local.naming_convention}-API"
  description = "API for Cloud Resume Challenge"
}

resource "aws_api_gateway_resource" "countVisitor" {
  rest_api_id = aws_api_gateway_rest_api.CloudResumeChallengeAPI.id
  parent_id   = aws_api_gateway_rest_api.CloudResumeChallengeAPI.root_resource_id
  path_part   = "countVisitor"
}