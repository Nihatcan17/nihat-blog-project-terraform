resource "aws_vpc" "capstone-vpc" {
  cidr_block = "10.16.0.0/16"
  tags = {
    "Name" = "${var.tags}-vpc"
  }
}

resource "aws_subnet" "public-1a" {
  cidr_block = "10.16.1.0/24"
  vpc_id     = aws_vpc.capstone-vpc.id
  tags = {
    "Name" = "${var.tags}-public-1a"
  }
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public-1b" {
  cidr_block = "10.16.2.0/24"
  vpc_id     = aws_vpc.capstone-vpc.id
  tags = {
    "Name" = "${var.tags}-public-1b"
  }
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private-1a" {
  cidr_block = "10.16.4.0/24"
  vpc_id     = aws_vpc.capstone-vpc.id
  tags = {
    "Name" = "${var.tags}-private-1a"
  }
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private-1b" {
  cidr_block = "10.16.5.0/24"
  vpc_id     = aws_vpc.capstone-vpc.id
  tags = {
    "Name" = "${var.tags}-private-1b"
  }
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "capstone_igw" {
  vpc_id = aws_vpc.capstone-vpc.id

}

resource "aws_route_table" "public-table" {
  vpc_id = aws_vpc.capstone-vpc.id


  route {
    gateway_id = aws_internet_gateway.capstone_igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "${var.tags}-public-table"
  }
}

resource "aws_route_table" "private-table" {
  vpc_id = aws_vpc.capstone-vpc.id

  tags = {
    "Name" = "${var.tags}-private-table"
  }
  route {
    instance_id = aws_instance.nat-instance.id
    cidr_block  = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "public-route-1a" {
  route_table_id = aws_route_table.public-table.id
  subnet_id      = aws_subnet.public-1a.id
}

resource "aws_route_table_association" "public-route-1b" {
  route_table_id = aws_route_table.public-table.id
  subnet_id      = aws_subnet.public-1b.id
}

resource "aws_route_table_association" "private-route-1a" {
  route_table_id = aws_route_table.private-table.id
  subnet_id      = aws_subnet.private-1a.id
}

resource "aws_route_table_association" "private-route-1b" {
  route_table_id = aws_route_table.private-table.id
  subnet_id      = aws_subnet.private-1b.id
}

