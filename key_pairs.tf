# TF Challenge #1

# To generate a private key
#resource "tls_private_key" "lcchua-tf-key-pair" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}

# To create AWS key pair
#resource "aws_key_pair" "lcchua-tf-key-pair" {
#  key_name   = "lcchua-key-pair"
#  public_key = tls_private_key.key_pair.public_key_openssh
#
#  tags = {
#    group = var.stack_name
#    Name  = "stw-key-pair"
#  }
#}

# To save the private key to a local file
#resource "local_sensitive_file" "pem_file" {
#  filename = "${path.module}/my-key-pair.pem"
#  content  = tls_private_key.key_pair.private_key_pem
#  file_permission = "0400"
#}

#output "key-pair" {
#  description = "19 stw ec2 key pairs"
#  value = aws_security_group.lcchua-tf-sg-allow-ssh-http-https.id
#}
