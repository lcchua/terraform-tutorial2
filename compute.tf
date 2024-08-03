
#============ EC2 INSTANCE =============

data "aws_ami" "lcchua-tf-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "description"
    values = ["*Amazon Linux 2023 AMI*"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023.5.20240722.0-kernel-6.1-x86_64"]
  }
# To comment out in case the AMI image id changes over time by AWS
/*
  filter {
    name   = "image-id"
    values = ["ami-0427090fd1714168b"]
  }
*/
}
output "ami" {
  description = "17a stw ami"
  value       = data.aws_ami.lcchua-tf-ami.id
}

resource "aws_instance" "lcchua-tf-ec2" {
  ami           = data.aws_ami.lcchua-tf-ami.id
  instance_type = "t2.micro"

  // key_name = var.key_name
  # TF Challenge #1 - to create an EC2 key pair using Terraform, 
  # and also download the key pair to your local machine for you to 
  # use to connect to the EC2 instance
  key_name      = aws_key_pair.lcchua-tf-key-pair.key_name

  subnet_id                   = aws_subnet.lcchua-tf-public-subnet-az1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lcchua-tf-sg-allow-ssh-http-https.id]

  # TF Challenge #2 - to update the previously created EC2 with a user 
  # data script passed in. This is to convert your EC2 into a HTTPD web server.
  user_data_replace_on_change = true    // to trigger a destroy and recreate
  user_data = file("${path.module}/ws_install.sh")

  # Enable detailed monitoring
  //monitoring                  = true

  tags = {
    group = var.stack_name
    Name  = "stw-ec2-server"
  }
}

output "ec2" {
  description = "17b stw EC2 server"
  value       = aws_instance.lcchua-tf-ec2.id
}
output "user-data" {
  description = "20 stw user data"
  value       = "${path.module}/ws_install.sh"
}