output "instance_ids" {
  value = data.aws_instances.todoapp.ids
}

output "instance_public_ip" {
  value = data.aws_instances.todoapp.public_ips
}

output "db_address" {
  value = data.aws_db_instance.todoapp.address
}
