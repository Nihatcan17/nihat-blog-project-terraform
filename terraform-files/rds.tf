resource "aws_db_instance" "capstone-project" {
  allocated_storage           = 20
  db_name                     = "capstonedatabase"
  engine                      = "mysql"
  engine_version              = "8.0.25"
  instance_class              = "db.t2.micro"
  username                    = "admin"
  password                    = var.db-password
  multi_az                    = false
  skip_final_snapshot         = true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  db_subnet_group_name        = aws_db_subnet_group.capstone_db.id
  vpc_security_group_ids      = [aws_security_group.rds-sec.id]
}

resource "aws_db_subnet_group" "capstone_db" {
  subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1b.id]
  name       = "${var.tags}-db-subnet-group"

}