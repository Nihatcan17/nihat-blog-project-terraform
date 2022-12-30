resource "aws_s3_bucket" "capstone-s3" {
  bucket        = var.bucket-name
  force_destroy = true

}
resource "aws_s3_bucket_public_access_block" "capstone-access" {
  bucket            = aws_s3_bucket.capstone-s3.bucket
  block_public_acls = false
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.capstone-s3.bucket
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : "${aws_s3_bucket.capstone-s3.arn}/*"
      }
    ]
  })
}


resource "aws_s3_bucket" "failover" {
  bucket = "blog.${var.domain}"
  force_destroy = true
  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "failover-access" {
  bucket            = aws_s3_bucket.failover.bucket
  block_public_acls = false
  
}

resource "aws_s3_bucket_policy" "bucket-policy-failover" {
  bucket = aws_s3_bucket.failover.bucket
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:Getobject",
        "Resource" : "${aws_s3_bucket.failover.arn}/*"
      }
    ]
  })
}


resource "aws_s3_bucket_versioning" "failoverversioning" {
  bucket = aws_s3_bucket.failover.bucket
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.failover.bucket
  key    = "index.html"
  source = "./S3_Static_Website/index.html"
  content_type = "text/html"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "objectjpeg" {
  bucket = aws_s3_bucket.failover.bucket
  key    = "sorry.jpg"
  source = "./S3_Static_Website/sorry.jpg"
}

resource "aws_s3_bucket_website_configuration" "failoverwebsite" {
  bucket = aws_s3_bucket.failover.bucket
  
  index_document {
    suffix = "index.html"
  }
  
}

