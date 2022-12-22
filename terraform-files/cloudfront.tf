resource "aws_cloudfront_distribution" "cf-blog" {
    origin {
      domain_name = aws_lb.capstone-lb.dns_name
      origin_id = "ALBOriginId"
    }
    

    enabled = false
    restrictions {
      geo_restriction {
        restriction_type = "none"
      }
    }
    default_cache_behavior {
      compress = false
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods = [ "GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE" ]
      target_origin_id = "ALBOriginId"
      cached_methods =  ["GET", "HEAD", "OPTIONS"] 
    }
    depends_on = [
      aws_lb.capstone-lb
    ]

    price_class = "PriceClass_All"
    viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.certificate.arn
    }
   
    http_version = "http2"
    is_ipv6_enabled = false
    
    
  
}

data "aws_acm_certificate" "certificate" {
  domain = "awscan.link"  # change here (you must write own domain name )
}

