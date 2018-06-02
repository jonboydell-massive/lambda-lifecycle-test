resource "aws_cloudfront_distribution" "cloudfront" {

  enabled = true
  restrictions {
    "geo_restriction" {
      restriction_type = "none"
    }
  }

  origin {
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "${module.echo_chamber.echo_chamber_host_name}"
    origin_id = "test-origin"
  }

  default_cache_behavior {
    allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods = ["HEAD", "GET"]
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
      headers = ["*"]
    }
    target_origin_id = "test-origin"
    viewer_protocol_policy = "allow-all"
    max_ttl = 0
    min_ttl = 0
    default_ttl = 0
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags {
    Owner = "${var.owner_email}"
    Project = "${var.project_name}"
  }
}

output "cloudfront_id" {
  value = "${aws_cloudfront_distribution.cloudfront.id}"
}

output "cloudfront_domain_name" {
  value = "${aws_cloudfront_distribution.cloudfront.domain_name}"
}

