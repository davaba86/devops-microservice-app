locals {
  ansible_inventory_yml = yamlencode({
    "all" : {
      "children" : {
        "web_servers" : {
          "hosts" : {
            for host in data.aws_instances.todoapp.public_ips : host => null
          },
          "vars" : {
            "ansible_python_interpreter" : "/usr/bin/python3.7",
            "ansible_ssh_private_key_file" : "../${var.iac_folder}/${data.local_file.ec2_key.filename}",
            "ansible_ssh_user" : "ec2-user"
          }
        }
      }
    }
  })
}

resource "local_file" "ansible_inventory" {
  content  = local.ansible_inventory_yml
  filename = format("%s/%s", abspath(path.root), "../${var.cm_folder}/inventory.yml")
}

data "local_file" "ansible_inventory" {
  filename = "${path.module}/../${var.cm_folder}/inventory.yml"

  depends_on = [
    local_file.ansible_inventory
  ]
}
