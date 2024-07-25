
#============ EC2 INSTANCE =============

data "aws_ami" "lcchua-tf-ami" {

  filter {
    name   = "name"
    values = ["Amazon Linux 2023*"]
  }
}
output "ami" {
  description = "17a stw ami"
  value = data.aws_ami.lcchua-tf-ami.id
}

resource "aws_instance" "lcchua-tf-ec2" {
  ami           = data.aws_ami.lcchua-tf-ami.id
  instance_type = "t2.micro"

  key_name      = var.key_name
  subnet_id     = aws_subnet.lcchua-tf-public-subnet-az1
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.lcchua-tf-sg-allow-ssh-http-https.id]

  tags = {
    group = var.stack_name
    Name = "stw-ec2-server"
  }
}
output "ec2" {
  description = "17b stw EC2 server"
  value = aws_instance.lcchua-tf-ec2.id
}