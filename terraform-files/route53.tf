resource "aws_route53_health_check" "healtcheck" {
  fqdn              = aws_cloudfront_distribution.cf-blog.domain_name
  port              = 80
  type              = "HTTP"
  failure_threshold = "3"
  request_interval  = "30"
  depends_on = [
    aws_cloudfront_distribution.cf-blog
  ]
  tags = {
    Name = "${var.tags}-health-check"
  }
}

data "aws_route53_zone" "hosted-zone" {
    name = "${var.domain}" 
}

resource "aws_route53_record" "dev-ns" {
  zone_id = data.aws_route53_zone.hosted-zone.id
  name    = "blog.${var.domain}"
  type    = "A"
  depends_on = [
    aws_cloudfront_distribution.cf-blog
  ]
  alias {
    name = aws_cloudfront_distribution.cf-blog.domain_name
    zone_id = aws_cloudfront_distribution.cf-blog.hosted_zone_id
    evaluate_target_health = false  
  }
  health_check_id = aws_route53_health_check.healtcheck.id
  failover_routing_policy {
    type = "PRIMARY"
  }
  set_identifier = "blog"
}

resource "aws_route53_record" "failover" {
  zone_id = data.aws_route53_zone.hosted-zone.id
   name    = "blog.${var.domain}"
  type    = "A"
  depends_on = [
    aws_route53_record.dev-ns
  ]
  alias {
    name = aws_s3_bucket.failover.website_domain
    zone_id = aws_s3_bucket.capstone-s3.hosted_zone_id
    evaluate_target_health = true
  }
  failover_routing_policy {
    type = "SECONDARY"
  }
  
  set_identifier = "fail"
  
}