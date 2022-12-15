data "aws_ami" "nat-ami" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}




resource "aws_instance" "nat-instance" {
  ami                         = data.aws_ami.nat-ami.id
  instance_type               = var.ec2-type
  key_name                    = var.key
  subnet_id                   = aws_subnet.public-1a.id
  security_groups             = [aws_security_group.nat-instance.id]
  source_dest_check           = false
  associate_public_ip_address = true
  tags = {
    "Name" = "${var.tags}-nat-instance"
  }
}

