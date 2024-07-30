# To generate a private key
resource "tls_private_key" "lcchua-tf-rsa-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# To create AWS key pair resource using the public key
resource "aws_key_pair" "lcchua-tf-key-pair" {
  key_name   = var.key_name
  public_key = tls_private_key.lcchua-tf-rsa-key.public_key_openssh

  tags = {
    group = var.stack_name
    Name  = "stw-key-pair"
  }
}

# To save the private key to a local file
resource "local_file" "pem_file" {
  content  = tls_private_key.lcchua-tf-rsa-key.private_key_pem
  filename = "${var.working_dir}/${var.key_name}.pem"
  file_permission = "0400"
}

output "key-pair" {
  description = "19 stw ec2 key pairs"
  value = aws_key_pair.lcchua-tf-key-pair.key_pair_id
}
