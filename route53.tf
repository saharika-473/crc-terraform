resource "aws_route53_zone" "primary" {
  name = "rahulpatel.cloud"
  comment = "Custom domain from Go Daddy"
  tags = var.tags
}

resource "aws_route53_record" "MyRoute53Record" {
  zone_id = aws_route53_zone.primary.zone_id

  name    = "www.rahulpatel.cloud"
  type    = "A"

  alias {
    name    = aws_cloudfront_distribution.MyDistribution.domain_name
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "AWSRoute53Record" {
  zone_id = aws_route53_zone.primary.zone_id

  name    = "aws.rahulpatel.cloud"
  type    = "A"

  alias {
    name    = aws_route53_record.MyRoute53Record.name
    zone_id = "Z05257462V5HZM915307D"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "NSRoute53Record" {
  zone_id = aws_route53_zone.primary.zone_id

  name    = "rahulpatel.cloud"
  type    = "NS"
  ttl     = 172800

  records = [ "ns-23.awsdns-02.com.", "ns-1273.awsdns-31.org.", "ns-971.awsdns-57.net.", "ns-1712.awsdns-22.co.uk." ]
}

resource "aws_route53_record" "SOARoute53Record" {
  zone_id = aws_route53_zone.primary.zone_id

  name    = "rahulpatel.cloud"
  type    = "SOA"
  ttl     = 900

  records = [ "ns-23.awsdns-02.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400" ]
}

resource "aws_route53_record" "CNAME1Route53Record" {
  zone_id = aws_route53_zone.primary.zone_id

  name    = "_7eaa71837c1bba978d1db63cfefd3a6c.rahulpatel.cloud"
  type    = "CNAME"
  ttl     = 300

  records = [ "_0913b7dce3294c3a2bf69a3ffc087ac2.mhbtsbpdnt.acm-validations.aws." ]
}

resource "aws_route53_record" "CNAME2Route53Record" {
  zone_id = aws_route53_zone.primary.zone_id

  name    = "_82889e8f1686df7ce61de80772b0317c.aws.rahulpatel.cloud"
  type    = "CNAME"
  ttl     = 300

  records = [ "_e74127dc03a611f43187b2ee3e68ddce.mhbtsbpdnt.acm-validations.aws." ]
}

resource "aws_route53_record" "CNAME3Route53Record" {
  zone_id = aws_route53_zone.primary.zone_id

  name    = "_92c48bfe319b92cdf250e2a707413c3a.www.rahulpatel.cloud"
  type    = "CNAME"
  ttl     = 300

  records = [ "_bf570369bf6b23696db2ee26540e2495.mhbtsbpdnt.acm-validations.aws." ]
}