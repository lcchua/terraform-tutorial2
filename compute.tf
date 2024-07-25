
#============ EC2 INSTANCE =============

data "aws_ami" "lcchua-tf-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name    = "description"
    values  = ["*Amazon Linux 2023 AMI*"] 
  }
  filter {
    name    = "name"
    values  = ["al2023-ami-2023.5.20240722.0-kernel-6.1-x86_64"]
  }
  filter {
    name    = "image-id"
    values  = ["ami-0427090fd1714168b"]
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
#  key_name      = aws_key_pair.lcchua-tf-key-pair.key_name
#  subnet_id     = aws_subnet.lcchua-tf-public-subnet-az1.id
  subnet_id     = aws_subnet.lcchua-tf-private-subnet-az1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.lcchua-tf-sg-allow-ssh-http-https.id]

# User data script to convert the EC2 server into a HTTPD web server
#  user_data = <<EOF
#    #!/bin/bash
#    echo "Installing the httpd and docker packages to the EC2 server..."
#    yum update -y
#    yum install httpd -y
#    yum install docker -y
#    systemctl start httpd.service
#    systemctl enable httpd.service
#    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
#  EOF

  tags = {
    group = var.stack_name
    Name = "stw-ec2-server"
  }
}
output "ec2" {
  description = "17b stw EC2 server"
  value = aws_instance.lcchua-tf-ec2.id
}