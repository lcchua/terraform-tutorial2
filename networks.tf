
#============ VPC =============
# Note that when a VPC is created, a main route table it created by default
# that is responsible for enabling the flow of network traffic within the VPC

resource "aws_vpc" "lcchua-tf-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    group = var.stack_name
    Name  = "stw-vpc"
  }
}
output "vpc-id" {
  description = "1 stw vpc"
  value       = aws_vpc.lcchua-tf-vpc.id
}


#============ INTERNET GATEWAY =============

resource "aws_internet_gateway" "lcchua-tf-igw" {
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  tags = {
    group = var.stack_name
    Name  = "stw-igw"
  }
}
output "igw" {
  description = "2 stw igw"
  value       = aws_internet_gateway.lcchua-tf-igw.id
}


#============ SUBNETS =============

# Private subnet az1
resource "aws_subnet" "lcchua-tf-private-subnet-az1" {
  vpc_id            = aws_vpc.lcchua-tf-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az1

  tags = {
    group = var.stack_name
    Name  = "stw-subnet-private-az1"
  }
}
output "private-subnet-az1" {
  description = "3 stw subnet private subnet az1"
  value       = aws_subnet.lcchua-tf-private-subnet-az1.id
}

# Private subnet az2
resource "aws_subnet" "lcchua-tf-private-subnet-az2" {
  vpc_id            = aws_vpc.lcchua-tf-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az2

  tags = {
    group = var.stack_name
    Name  = "stw-subnet-private-az2"
  }
}
output "private-subnet-az2" {
  description = "4 stw subnet private subnet az2"
  value       = aws_subnet.lcchua-tf-private-subnet-az2.id
}

# Public subnet az1
resource "aws_subnet" "lcchua-tf-public-subnet-az1" {
  vpc_id                  = aws_vpc.lcchua-tf-vpc.id
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az1

  tags = {
    group = var.stack_name
    Name  = "stw-subnet-public-az1"
  }
}
output "public-subnet-az1" {
  description = "5 stw subnet public subnet az1"
  value       = aws_subnet.lcchua-tf-public-subnet-az1.id
}

# Public subnet az2
resource "aws_subnet" "lcchua-tf-public-subnet-az2" {
  vpc_id                  = aws_vpc.lcchua-tf-vpc.id
  cidr_block              = "10.0.102.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az2

  tags = {
    group = var.stack_name
    Name  = "stw-subnet-public-az2"
  }
}
output "public-subnet-az2" {
  description = "6 stw subnet public subnet az2"
  value       = aws_subnet.lcchua-tf-public-subnet-az2.id
}


#============ NAT GATEWAY + EIP =============

resource "aws_nat_gateway" "lcchua-tf-nat-gw" {
  allocation_id = aws_eip.lcchua-tf-eip.id
  subnet_id     = aws_subnet.lcchua-tf-public-subnet-az1.id

  tags = {
    Name  = "stw-nat-gw"
    group = var.stack_name
  }
}
output "nat-gw" {
  description = "7 stw NAT gateway"
  value       = aws_nat_gateway.lcchua-tf-nat-gw.id
}

resource "aws_eip" "lcchua-tf-eip" {
  tags = {
    group = var.stack_name
    Name  = "stw-eip"
  }
}
output "eip" {
  description = "8 stw EIP"
  value       = aws_eip.lcchua-tf-eip.id
}


#============ ROUTE TABLES =============

# Private rtb az1
resource "aws_route_table" "lcchua-tf-private-rtb-az1" {
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = aws_vpc.lcchua-tf-vpc.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lcchua-tf-nat-gw.id
  }

  tags = {
    group = var.stack_name
    Name  = "stw-private-rtb-az1"
  }
}
output "private-rtb-az1" {
  description = "9a stw private subnet route table"
  value       = aws_route_table.lcchua-tf-private-rtb-az1.id
}

# Private rtb az2
resource "aws_route_table" "lcchua-tf-private-rtb-az2" {
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = aws_vpc.lcchua-tf-vpc.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lcchua-tf-nat-gw.id
  }

  tags = {
    group = var.stack_name
    Name  = "stw-private-rtb-az2"
  }
}
output "private-rtb-az2" {
  description = "9b stw private subnet route table"
  value       = aws_route_table.lcchua-tf-private-rtb-az2.id
}

# Public rtb
resource "aws_route_table" "lcchua-tf-public-rtb" {
  vpc_id = aws_vpc.lcchua-tf-vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = aws_vpc.lcchua-tf-vpc.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lcchua-tf-igw.id
  }

  tags = {
    group = var.stack_name
    Name  = "stw-public-rtb"
  }
}
output "public-rtb" {
  description = "10 stw all public subnets route table"
  value       = aws_route_table.lcchua-tf-public-rtb.id
}


#============ ROUTE TABLES ASSOCIATIONS =============

# Public rta az1
resource "aws_route_table_association" "lcchua-tf-public-rta-az1" {
  subnet_id      = aws_subnet.lcchua-tf-public-subnet-az1.id
  route_table_id = aws_route_table.lcchua-tf-public-rtb.id
}
output "public-rta-az1" {
  description = "11 stw public rta az1"
  value       = aws_route_table_association.lcchua-tf-public-rta-az1.id
}

# Pubic rta az2
resource "aws_route_table_association" "lcchua-tf-public-rta-az2" {
  subnet_id      = aws_subnet.lcchua-tf-public-subnet-az2.id
  route_table_id = aws_route_table.lcchua-tf-public-rtb.id
}
output "public-rta-az2" {
  description = "12 stw public rta az2"
  value       = aws_route_table_association.lcchua-tf-public-rta-az2.id
}

# Private rta az1
resource "aws_route_table_association" "lcchua-tf-private-rta-az1" {
  subnet_id      = aws_subnet.lcchua-tf-private-subnet-az1.id
  route_table_id = aws_route_table.lcchua-tf-private-rtb-az1.id
}
output "private-rta-az1" {
  description = "13 stw private rta az1"
  value       = aws_route_table_association.lcchua-tf-private-rta-az1.id
}

# Private rta az2
resource "aws_route_table_association" "lcchua-tf-private-rta_az2" {
  subnet_id      = aws_subnet.lcchua-tf-private-subnet-az2.id
  route_table_id = aws_route_table.lcchua-tf-private-rtb-az2.id
}
output "private-rta-az2" {
  description = "14 stw private rta az2"
  value       = aws_route_table_association.lcchua-tf-private-rta_az2.id
}


#============ VPC ENDPOINT FOR S3 =============

resource "aws_vpc_endpoint" "lcchua-tf-vpce-s3" {
  vpc_id            = aws_vpc.lcchua-tf-vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.lcchua-tf-public-rtb.id
    #    aws_route_table.lcchua-tf-private-rtb-az1.id,
    #    aws_route_table.lcchua-tf-private-rtb-az2.id,
    #    aws_route_table.lcchua-tf-public-rtb.id
  ]

  tags = {
    group = var.stack_name
    Name  = "stw-vpc-s3-endpoint"
  }
}
output "vpce-s3" {
  description = "15 stw vpc endpoint for s3"
  value       = aws_vpc_endpoint.lcchua-tf-vpce-s3.id
}

#============ SECURITY GROUP =============

resource "aws_security_group" "lcchua-tf-sg-allow-ssh-http-https" {
  name   = "lcchua-tf-sg-allow-ssh-http-https"
  vpc_id = aws_vpc.lcchua-tf-vpc.id

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
    Name  = "stw-sg-ssh-http-https"
  }
}
output "web-sg" {
  description = "16 stw web security group for ssh http https"
  value       = aws_security_group.lcchua-tf-sg-allow-ssh-http-https.id
}
