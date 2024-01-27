output "website_url" {
  value = aws_s3_bucket_website_configuration.example.website_endpoint
}

output "CloudFrontDistributionDomainName" {
  value       = aws_cloudfront_distribution.MyDistribution.domain_name
  description = "Domain name of the CloudFront distribution"
}