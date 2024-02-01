resource "aws_api_gateway_rest_api" "CloudResumeChallengeAPI" {
  name        = "${local.naming_convention}-API"
  description = "API for Cloud Resume Challenge"
}