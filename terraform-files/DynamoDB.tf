resource "aws_dynamodb_table" "dynamo" {
  name           = "blog-project-nihat" # must be uniq!!
  billing_mode   = "PROVISIONED"
  hash_key       = "blog-project"
  stream_enabled = false

  depends_on = [
    aws_s3_bucket
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
  ttl {
    enabled = false
  }

  tags = {
    "Name" = "${var.tags}-table"
  }
}
