data "template_file" "userdata" {
  template = file("${abspath(path.module)}/userdata.sh")
  vars = {
    rds-endpoint = aws_db_instance.capstone-project.address
    rds-name = aws_db_instance.capstone-project.db_name
    rds-passwd = aws_db_instance.capstone-project.password
    rds-user-name = aws_db_instance.capstone-project.username
    BucketName = aws_s3_bucket.capstone-s3.bucket
    rds-port = 3306
  }
}
resource "aws_launch_template" "asg-lt" {
  image_id = "ami-0ee23bfc74a881de5"
  key_name = var.key
  network_interfaces {
    subnet_id = aws_subnet.private-1a.id
    security_groups = [ "${aws_security_group.ec2-sec.id}" ]
  }
  depends_on = [
    aws_instance.nat-instance
  ]
  instance_type = "t2.micro"
  monitoring {
    enabled = false
  }
  user_data = "${base64encode(data.template_file.userdata.rendered)}"
  iam_instance_profile {
    arn = aws_iam_instance_profile.iam-profil.arn
  }
  tags = {
    Name = "${var.tags}-launch-template"
  }
  name = "${var.tags}-launch-template"

}


resource "aws_iam_instance_profile" "iam-profil" {
  name = "iamprofil"
  role = aws_iam_role.s3forec2.name

}

resource "aws_iam_role" "s3forec2" {
  name = "s3accessrole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

