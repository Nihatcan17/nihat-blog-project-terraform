locals {
  api_origin_id = "Loadbalanceroriginid"
}

resource "aws_cloudfront_distribution" "cf-blog" {
    origin {
      domain_name = aws_lb.capstone-lb.dns_name
      origin_id = local.api_origin_id
      custom_origin_config {
        http_port = 80
        https_port = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols = [ "TLSv1" ]
        origin_keepalive_timeout = "5"
      }
    }
    
    aliases = [ "blog.${var.domain}" ]
    
    enabled = true
    restrictions {
      geo_restriction {
        restriction_type = "none"
      }
    }
    default_cache_behavior {
      compress = true
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods = [ "GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE" ]
      target_origin_id = local.api_origin_id
      cached_methods =  ["GET", "HEAD", "OPTIONS"] 
      smooth_streaming = false
      
      forwarded_values {
        query_string = true
        cookies {
          forward = "all"  
        }
        headers = [ "*" ]
      }
    }
    depends_on = [
      aws_lb.capstone-lb
    ]

    price_class = "PriceClass_All"
    viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.certificate.arn
    ssl_support_method = "sni-only"
    
    }
   
    http_version = "http2"
    is_ipv6_enabled = false
     
    
  
}

data "aws_acm_certificate" "certificate" {
  domain = "${var.domain}"  
}

