resource "aws_acm_certificate" "MyCertificate" {
  domain_name       = "rahulpatel.cloud"
  validation_method = "DNS"

  subject_alternative_names = [
    "rahulpatel.cloud",
    "www.rahulpatel.cloud",
    "aws.rahulpatel.cloud",
  ]

    tags = var.tags
}