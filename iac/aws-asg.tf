data "aws_ami" "amazon_linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["137112412989"]
}

resource "aws_launch_template" "todoapp" {
  name          = "todoapp"
  image_id      = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_web_type
  key_name      = aws_key_pair.ec2.key_name

  vpc_security_group_ids = [
    module.sg_ssh.security_group_id,
    module.sg_todoapp.security_group_id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "todoapp"
      ASG  = "todoapp"
    }
  }
}

resource "aws_autoscaling_group" "todoapp" {
  name = "todoapp"

  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = module.vpc_devops_todoapp.public_subnets

  launch_template {
    id      = aws_launch_template.todoapp.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }
}

resource "null_resource" "provision_todoapp" {
  provisioner "local-exec" {
    working_dir = "../${var.cm_folder}"
    command     = "ansible-playbook main.yml"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    data.aws_instances.todoapp,
    data.local_file.docker_compose
  ]
}
