resource "aws_iam_role" "lambda_role" {
  name               = "${var.tags}-lambda-Role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

data "aws_iam_policy" "s3-full-access" {
  name = "AmazonS3FullAccess"

}

data "aws_iam_policy" "Dynamo-full-access" {
  name = "AmazonDynamoDBFullAccess"
}

data "aws_iam_policy" "network-policy" {
  name = "NetworkAdministrator"
}

resource "aws_iam_role_policy_attachment" "lamda-attach" {
  for_each = toset([
    "${data.aws_iam_policy.s3-full-access.arn}",
    "${data.aws_iam_policy.Dynamo-full-access.arn}",
    "${data.aws_iam_policy.network-policy.arn}"
  ])
  role       = aws_iam_role.lambda_role.name
  policy_arn = each.value
}

