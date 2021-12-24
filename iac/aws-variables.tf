data "aws_region" "current" {}

variable "vpc_cidr_block" {
  default = "172.16.0.0/16"
}

variable "instance_web_type" {
  default = "t2.micro"
}

variable "project_name" {
  default = "devops_todoapp"
}

variable "environment" {
  default = "dev"
}

data "aws_instances" "todoapp" {
  instance_tags = {
    ASG = "todoapp"
  }

  depends_on = [
    aws_autoscaling_group.todoapp
  ]
}

data "aws_db_instance" "todoapp" {
  db_instance_identifier = aws_db_instance.todoapp.id
}

variable "iac_folder" {
  description = "Folder for storing Infrastructure as Code files."
  default     = "iac"
}

variable "cm_folder" {
  description = "Folder for storing Configuration Management files."
  default     = "cm"
}

variable "rds_admin" {
  default = "db_admin"
}

variable "rds_password" {
  default = "2ld9cn475435vb7557vm"
}

variable "rds_dbname" {
  default = "todoapp"
}
