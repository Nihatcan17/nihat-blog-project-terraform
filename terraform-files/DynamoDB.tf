resource "aws_dynamodb_table" "dynamo" {
  name           = "blog-project-nihat" # do not change !!
  billing_mode   = "PROVISIONED"
  hash_key       = "id"
  stream_enabled = false
  
  depends_on = [
    aws_s3_bucket.capstone-s3
  ]
  read_capacity  = 1
  write_capacity = 1
  point_in_time_recovery {
    enabled = false
  }
  attribute {
    name = "id"
    type = "S"
  }
  

  tags = {
    "Name" = "${var.tags}-table"
  }
}
