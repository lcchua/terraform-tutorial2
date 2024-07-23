terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
#  region  = "us-east-1"
#  profile = "lcchua7"
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

resource "aws_internet_gateway" "stw_gw" {
  vpc_id = aws_vpc.stw_vpc.id

  tags = {
    group = var.stack_name
    Name  = "stw_gw"
  }
}


#============ SUBNETS =============

resource "aws_subnet" "stw_subnet_private_1" {
  vpc_id            = aws_vpc.stw_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    group = var.stack_name
    Name  = "stw_subnet_private_1"
  }
}

resource "aws_subnet" "stw_subnet_private_2" {
  vpc_id            = aws_vpc.stw_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    group = var.stack_name
    Name  = "stw_subnet_private_2"
  }
}

resource "aws_subnet" "stw_subnet_public_1" {
  vpc_id                  = aws_vpc.stw_vpc.id
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"
  tags = {
    group = var.stack_name
    Name  = "stw_subnet_public_1"
  }
}

resource "aws_subnet" "stw_subnet_public_2" {
  vpc_id                  = aws_vpc.stw_vpc.id
  cidr_block              = "10.0.102.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"
  tags = {
    group = var.stack_name
    Name  = "stw_subnet_public_2"
  }
}




#============ NAT GATEWAY =============

resource "aws_nat_gateway" "stw_nat_gw" {
  allocation_id = aws_eip.stw_eip.id
  subnet_id     = aws_subnet.stw_subnet_public_1.id

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



#============ ROUTE TABLES =============

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
    gateway_id = aws_internet_gateway.stw_gw.id
  }

  tags = {
    group = var.stack_name
    Name  = "stw-rt-public"
  }
}


resource "aws_route_table_association" "stw_rta_public_1" {
  subnet_id      = aws_subnet.stw_subnet_public_1.id
  route_table_id = aws_route_table.stw_rt_public.id
}
resource "aws_route_table_association" "stw_rta_public_2" {
  subnet_id      = aws_subnet.stw_subnet_public_2.id
  route_table_id = aws_route_table.stw_rt_public.id
}
resource "aws_route_table_association" "stw_rta_private_1" {
  subnet_id      = aws_subnet.stw_subnet_private_1.id
  route_table_id = aws_route_table.stw_rt_private.id
}
resource "aws_route_table_association" "stw_rta_private_2" {
  subnet_id      = aws_subnet.stw_subnet_private_2.id
  route_table_id = aws_route_table.stw_rt_private.id
}
