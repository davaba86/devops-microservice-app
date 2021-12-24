locals {
  docker_compose_yml = yamlencode({
    "version" : "3.7",
    "services" : {
      "app" : {
        "image" : "node:12-alpine",
        "command" : "sh -c 'yarn install && yarn run dev'"
        "ports" : ["3000:3000"],
        "working_dir" : "/app",
        "volumes" : ["./app/:/app"],
        "environment" : {
          "MYSQL_HOST" : "${data.aws_db_instance.todoapp.address}",
          "MYSQL_DB" : "${var.rds_dbname}",
          "MYSQL_USER" : "${var.rds_admin}",
          "MYSQL_PASSWORD" : "${var.rds_password}"
        }
      }
    }
    "volumes" : {
      "todo-mysql-data" : null
    }
  })
}

resource "local_file" "docker_compose" {
  content  = local.docker_compose_yml
  filename = format("%s/%s", abspath(path.root), "../${var.cm_folder}/docker-compose.yml")
}

data "local_file" "docker_compose" {
  filename = "${path.module}/../${var.cm_folder}/docker-compose.yml"

  depends_on = [
    local_file.docker_compose
  ]
}
