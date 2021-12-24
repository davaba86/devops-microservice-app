resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2" {
  key_name   = "ec2-ssh-keys"
  public_key = tls_private_key.ec2.public_key_openssh
}

resource "local_file" "ec2_key" {
  sensitive_content = tls_private_key.ec2.private_key_pem
  filename          = "${path.module}/ec2_key.pem"
  file_permission   = "0600"
}

data "local_file" "ec2_key" {
  filename = "${path.module}/ec2_key.pem"

  depends_on = [
    local_file.ec2_key
  ]
}
