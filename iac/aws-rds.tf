resource "aws_db_subnet_group" "todoapp" {
  name       = "todoapp"
  subnet_ids = module.vpc_devops_todoapp.public_subnets

  tags = {
    Name        = "DB Public Subnet Group"
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_db_instance" "todoapp" {
  publicly_accessible = true
  identifier          = "todoapp"
  engine              = "mysql"
  engine_version      = "5.7"

  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  instance_class       = "db.t2.micro"
  allocated_storage    = 10

  name                   = var.rds_dbname
  username               = var.rds_admin
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.todoapp.name
  vpc_security_group_ids = [module.sg_mysql.security_group_id]

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project_name
  }
}
