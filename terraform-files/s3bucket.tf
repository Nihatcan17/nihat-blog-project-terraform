resource "aws_s3_bucket" "capstone-s3" {
    bucket = var.bucket-name
    force_destroy = true
    
}
resource "aws_s3_bucket_public_access_block" "capstone-access" {
  bucket = aws_s3_bucket.capstone-s3.bucket
  block_public_acls = false
}

resource "aws_s3_bucket_policy" "bucket-policy" {
    bucket = aws_s3_bucket.capstone-s3.bucket
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.capstone-s3.arn}/*"
        }
        ]   
    })
}

