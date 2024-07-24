

#============ MAIN =============

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

# To comment backend block if working on local and terraform state file is locally stored
  backend "s3" {
    bucket = "sctp-ce7-tfstate" 
    key    = "terraform-ex-ec2-lcchua.tfstate" #Change the value of this to <your suggested name>.tfstate for  example
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}


#============ VPC =============

resource "aws_vpc" "stw_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    group = var.stack_name
    Name  = "stw_vpc"
  }
}


#============ INTERNET GATEWAY =============

resource "aws_internet_gateway" "stw_igw" {
  vpc_id = aws_vpc.stw_vpc.id

  tags = {
    group = var.stack_name
    Name  = "stw_igw"
  }
}


#============ SUBNETS =============

resource "aws_subnet" "stw_subnet_private_1a" {
  vpc_id            = aws_vpc.stw_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    group = var.stack_name
    Name  = "stw_subnet_private_1a"
  }
}

resource "aws_subnet" "stw_subnet_private_1b" {
  vpc_id            = aws_vpc.stw_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    group = var.stack_name
    Name  = "stw_subnet_private_1b"
  }
}

resource "aws_subnet" "stw_subnet_public_1a" {
  vpc_id                  = aws_vpc.stw_vpc.id
  cidr_block              = "10.0.101.0/24"
#  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
 
  tags = {
    group = var.stack_name
    Name  = "stw_subnet_public_1a"
  }
}

resource "aws_subnet" "stw_subnet_public_1b" {
  vpc_id                  = aws_vpc.stw_vpc.id
  cidr_block              = "10.0.102.0/24"
#  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    group = var.stack_name
    Name  = "stw_subnet_public_1b"
  }
}


#============ NAT GATEWAY + EIP =============

resource "aws_nat_gateway" "stw_nat_gw" {
  allocation_id = aws_eip.stw_eip.id
  subnet_id     = aws_subnet.stw_subnet_public_1a.id

  tags = {
    Name  = "stw_nat_gw"
    group = var.stack_name
  }
}

resource "aws_eip" "stw_eip" {
  tags = {
    group = var.stack_name
    Name  = "stw_eip"
  }
}



#============ ROUTE TABLES + ASSOCIATIONS =============

resource "aws_route_table" "stw_rt_private" {
  vpc_id = aws_vpc.stw_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.stw_nat_gw.id
  }

  tags = {
    group = var.stack_name
    Name  = "stw-rt-private"
  }
}

resource "aws_route_table" "stw_rt_public" {
  vpc_id = aws_vpc.stw_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stw_igw.id
  }

  tags = {
    group = var.stack_name
    Name  = "stw-rt-public"
  }
}


resource "aws_route_table_association" "stw_rta_public_1a" {
  subnet_id      = aws_subnet.stw_subnet_public_1a.id
  route_table_id = aws_route_table.stw_rt_public.id
}
resource "aws_route_table_association" "stw_rta_public_1b" {
  subnet_id      = aws_subnet.stw_subnet_public_1b.id
  route_table_id = aws_route_table.stw_rt_public.id
}
resource "aws_route_table_association" "stw_rta_private_1a" {
  subnet_id      = aws_subnet.stw_subnet_private_1a.id
  route_table_id = aws_route_table.stw_rt_private.id
}
resource "aws_route_table_association" "stw_rta_private_1b" {
  subnet_id      = aws_subnet.stw_subnet_private_1b.id
  route_table_id = aws_route_table.stw_rt_private.id
}


#============ SECURITY GROUP =============

resource "aws_security_group" "stw_web_sg" {
  name   = "HTTP HTTPS SSH"
  vpc_id = aws_vpc.stw_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    group = var.stack_name
    Name  = "stw-web-sg"
  }
}



#============ EC2 =============

resource "aws_instance" "devops_ec2" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = aws_subnet.stw_subnet_public_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.stw_web_sg.id]

  tags = {
    group = var.stack_name
    Name = "stw-webserver"
  }
}



#============ S3 BUCKET =============

# Bucket with versioning enabled
resource "random_id" "s3_id" {
    byte_length = 2
}

resource "aws_s3_bucket" "devops_s3bucket" {
  bucket = "devops-bucket-${random_id.s3_id.dec}"
#  bucket_prefix = ""

  tags = {
      group = var.stack_name
      Env = "Dev"
      Name = "stw-s3-bucket"
  }
}

resource "aws_s3_bucket_acl" "devops_s3bucket_acl" {
  bucket = aws_s3_bucket.devops_s3bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "devops_s3bucket_versioning" {
  bucket = aws_s3_bucket.devops_s3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
