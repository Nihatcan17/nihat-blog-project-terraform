resource "aws_security_group" "nat-instance" {
  name   = "${var.tags}-nat-instance-sec"
  vpc_id = aws_vpc.capstone-vpc.id
  tags = {
    "Name" = "${var.tags}-nat-instance-sec-grp"
  }

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 443
    from_port   = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "load-balancer-sec" {
  name   = "${var.tags}-load-balancer-sec"
  vpc_id = aws_vpc.capstone-vpc.id
  tags = {
    Name = "${var.tags}-load-balancer-sec"
  }

  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    to_port     = 443
    from_port   = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2-sec" {
  vpc_id = aws_vpc.capstone-vpc.id
  name   = "${var.tags}-ec2-security-group"
  tags = {
    "Name" = "${var.tags}-ec2-security-group"
  }
  ingress {
    to_port         = 22
    from_port       = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.nat-instance.id}"]
  }

  ingress {
    to_port         = 80
    from_port       = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.load-balancer-sec.id}"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds-sec" {
  vpc_id = aws_vpc.capstone-vpc.id
  name   = "${var.tags}-rds-sec"
  tags = {
    Name = "${var.tags}-rds-sec-group"
  }

  ingress {
    to_port         = 3306
    from_port       = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ec2-sec.id}"]
  }

  egress {
    to_port         = 0
    from_port       = 0
    protocol        = -1
    security_groups = ["${aws_security_group.ec2-sec.id}"]
  }
}

