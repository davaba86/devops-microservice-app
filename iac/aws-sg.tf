module "sg_elb" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "elb"
  description = "Security group, allowing TCP 80 inbound traffic for todo application."
  vpc_id      = module.vpc_devops_todoapp.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "sg_ssh" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh"
  description = "Security group, allowing SSH inbound traffic."
  vpc_id      = module.vpc_devops_todoapp.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "sg_todoapp" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "todoapp"
  description = "Security group, allowing TCP 300 inbound traffic for todo application."
  vpc_id      = module.vpc_devops_todoapp.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "ToDo Application"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "sg_mysql" {
  source = "terraform-aws-modules/security-group/aws//modules/mysql"

  name        = "mysql"
  description = "Security group, allowing MySQL inbound traffic."
  vpc_id      = module.vpc_devops_todoapp.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}
