module "vpc_devops_todoapp" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.project_name
  cidr = var.vpc_cidr_block

  azs = [
    "${data.aws_region.current.name}a",
    "${data.aws_region.current.name}b",
    "${data.aws_region.current.name}c"
  ]
  public_subnets = ["172.16.101.0/24", "172.16.102.0/24", "172.16.103.0/24"]

  enable_dns_hostnames = true
  enable_nat_gateway   = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = "${var.project_name}"
  }
}
