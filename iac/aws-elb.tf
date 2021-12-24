module "alb_devops_todoapp" {
  source = "terraform-aws-modules/alb/aws"

  name               = "todoapp"
  load_balancer_type = "application"

  vpc_id          = module.vpc_devops_todoapp.vpc_id
  subnets         = module.vpc_devops_todoapp.public_subnets
  security_groups = [module.sg_elb.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = "todoapp"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
      targets = [
        { for instance in data.aws_instances.todoapp.ids : "target_id" => instance }
      ]
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project_name
  }
}

variable "list" {
  default = ["i-0123456789abcdefg"]
}

output "name" {
  value = [
    { for instance in var.list : "target_id" => instance }
  ]
}
