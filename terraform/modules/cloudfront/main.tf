locals {
  s3_origin_id = "my_museum_app_s3_origin"
}

# Use Origin Access Control (OAC):
# When using OAC, a typical request and response workflow will be: 
# 1. A client sends HTTP or HTTPS requests to CloudFront. 
# 2. CloudFront edge locations receive the requests. 
# If the requested object is not already cached, CloudFront signs the requests using OAC signing protocol (SigV4 is currently supported.) 
# 3. S3 origins authenticate, authorize, or deny the requests. 
# When configuring OAC, you can choose among three signing behaviors – “Do not sign requests”, 
# “Sign requests”, and sign requests but “Do not override authorization header” (Figure 1). 
# Next we will talk about OAC’s expected behaviors for each signing option.
resource "aws_cloudfront_origin_access_control" "s3_ori_access_control"{
    name = "museum_app_oac"
    description = "OAC policy for the museum app"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
}

# Create an Amazon CloudFront distribution for your subdomain (e.g. www.museumapp-demo.com)
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.s3_bucket_info.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_ori_access_control.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront Distribution CDN for Museum Rating App"
  default_root_object = "index.html"

# Diable Logging
#   logging_config {
#     include_cookies = false
#     bucket          = "mylogs.s3.amazonaws.com"
#     prefix          = "myprefix"
#   }

  aliases = [var.root_domain_name, var.sub_domain_name]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      # Allow USA and Canada
      locations        = ["US", "CA"]
    }
  }

  tags = {
    Environment = "development"
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert.arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "vip"
  }
}

data "aws_route53_zone" "app_com" {
  name         = var.root_domain_name
  private_zone = false
}

# Route DNS traffic for your domain to your CloudFront distribution
resource "aws_route53_record" "cdn_domain"{
    zone_id = data.aws_route53_zone.app_com.zone_id
    name = "www"
    type = "A"

    alias {
      name = aws_cloudfront_distribution.s3_distribution.domain_name
      zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
      evaluate_target_health = false
    }
}