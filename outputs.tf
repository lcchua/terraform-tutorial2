output "stw_vpc_id" {
  description = "1 stw vpc"
  value       = aws_vpc.stw_vpc.id
}

output "stw_igw" {
  description = "2 stw igw"
  value       = aws_internet_gateway.stw_igw.id
}

output "stw_subnet_private_1a_id" {
  description = "3 stw subnet private subnet 1a"
  value       = aws_subnet.stw_subnet_private_1a.id
}

output "stw_subnet_private_1b_id" {
  description = "4 stw subnet private subnet 1b"
  value       = aws_subnet.stw_subnet_private_1b.id
}

output "stw_subnet_public_1a_id" {
  description = "5 stw subnet public subnet 1a"
  value       = aws_subnet.stw_subnet_public_1a.id
}

output "stw_subnet_public_1b_id" {
  description = "6 stw subnet public subnet 1b"
  value       = aws_subnet.stw_subnet_public_1b.id
}

output "stw_nat_gw" {
  description = "7 stw NAT gateway"
  value       = aws_nat_gateway.stw_nat_gw.id
}

output "stw_eip" {
  description = "8 stw EIP"
  value       = aws_eip.stw_eip.id
}

output "stw_rt_private" {
  description = "9 stw private subnets route table"
  value       = aws_route_table.stw_rt_private.id
}

output "stw_rt_public" {
  description = "10 stw public subnets route table"
  value       = aws_route_table.stw_rt_public.id
}

output "stw_rta_public_1a" {
  description = "11 stw rta public 1a subnet"
  value       = aws_route_table_association.stw_rta_public_1a.id
}

output "stw_rta_public_1b" {
  description = "12 stw rta public 1b subnet"
  value       = aws_route_table_association.stw_rta_public_1b.id
}

output "stw_rta_private_1a" {
  description = "13 stw rta private 1a subnet"
  value       = aws_route_table_association.stw_rta_private_1a.id
}

output "stw_rta_private_1b" {
  description = "14 stw rta private 1b subnet"
  value       = aws_route_table_association.stw_rta_private_1b.id
}

output "stw_web_sg" {
  description = "15 stw web security group"
  value = aws_security_group.stw_web_sg.id
}

output "devops_ec2" {
  description = "16 stw devops EC2 server"
  value = aws_s3_bucket.devops_s3bucket.id
}

output "devops_s3bucket" {
  description = "17 stw devops S3 bucket"
  value = aws_s3_bucket.devops_s3bucket.id
}

output "devops_s3bucket_versioning" {
  description = "18 stw devops S3 bucket versioning"
  value = aws_s3_bucket_versioning.devops_s3bucket_versioning.id
}

output "devops_s3bucket_acl" {
  description = "19 stw devops S3 bucket acl set to public read"
  value = aws_s3_bucket_acl.devops_s3bucket_acl.id
}