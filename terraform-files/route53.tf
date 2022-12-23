resource "aws_route53_health_check" "healtcheck" {
  fqdn              = aws_cloudfront_distribution.cf-blog.domain_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"
  depends_on = [
    aws_cloudfront_distribution.cf-blog
  ]
  tags = {
    Name = "${var.tags}-health-check"
  }
}

data "aws_route53_zone" "hosted-zone" {
    name = "awscan.link" #change here
}

resource "aws_route53_record" "dev-ns" {
  zone_id = data.aws_route53_zone.hosted-zone.id
  name    = "blog"
  type    = "A"
  depends_on = [
    aws_cloudfront_distribution.cf-blog
  ]
  alias {
    name = aws_cloudfront_distribution.cf-blog.domain_name
    zone_id = data.aws_route53_zone.hosted-zone.zone_id
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
   name    = "blog"
  type    = "A"
  depends_on = [
    aws_route53_record.dev-ns
  ]
  alias {
    name = aws_s3_bucket.failover.website_domain
    zone_id = data.aws_route53_zone.hosted-zone.zone_id
    evaluate_target_health = true
  }
  failover_routing_policy {
    type = "SECONDARY"
  }
  
  set_identifier = "fail"
  
}