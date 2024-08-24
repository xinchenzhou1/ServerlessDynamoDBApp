#Create an ACM Certificate for the domain
resource "aws_acm_certificate" "app_certificate" {
  domain_name               = var.route53_root_domain
  subject_alternative_names = [var.sub_alt_name]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Extract the existing route53 zone public DNS records for the domain
data "aws_route53_zone" "app_com" {
  name         = var.route53_root_domain
  private_zone = false
}

# Create record in Route 53 to automatically add the CNAME records for your domains
resource "aws_route53_record" "acm_cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.app_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.app_com.zone_id
}

# DNS Validation
resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn         = aws_acm_certificate.app_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_cert_record : record.fqdn]
}