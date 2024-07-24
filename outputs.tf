output "stw_vpc_id" {
  description = "stw vpc"
  value       = aws_vpc.stw_vpc.id
}

output "stw_subnet_private_1a_id" {
  description = "stw subnet private subnet 1a"
  value       = aws_subnet.stw_subnet_private_1a.id
}

output "stw_subnet_private_1b_id" {
  description = "stw subnet private subnet 1b"
  value       = aws_subnet.stw_subnet_private_1b.id
}

output "stw_subnet_public_1a_id" {
  description = "stw subnet public subnet 1a"
  value       = aws_subnet.stw_subnet_public_1a.id
}

output "stw_subnet_public_1b_id" {
  description = "stw subnet public subnet 1b"
  value       = aws_subnet.stw_subnet_public_1b.id
}

output "stw_nat_gw" {
  description = "stw NAT gateway"
  value       = aws_nat_gateway.stw_nat_gw.id
}

output "stw_eip" {
  description = "stw EIP"
  value       = aws_eip.stw_eip.id
}

output "stw_rt_private" {
  description = "stw private subnets route table"
  value       = aws_route_table.stw_rt_private.id
}

output "stw_rt_public" {
  description = "stw public subnets route table"
  value       = aws_route_table.stw_rt_public.id
}

output "stw_rta_public_1a" {
  description = "stw rta public 1a subnet"
  value       = aws_route_table_association.stw_rta_public_1a.id
}

output "stw_rta_public_1b" {
  description = "stw rta public 1b subnet"
  value       = aws_route_table_association.stw_rta_public_1b.id
}

output "stw_rta_private_1a" {
  description = "stw rta private 1a subnet"
  value       = aws_route_table_association.stw_rta_private_1a.id
}

output "stw_rta_private_1b" {
  description = "stw rta private 1b subnet"
  value       = aws_route_table_association.stw_rta_private_1b.id
}

output "stw_web_sg" {
  description = "stw web security group"
  value = aws_security_group.stw_web_sg.id
}

output "devops_ec2" {
  description = "stw devops EC2 server"
  value = aws_s3_bucket.devops_s3bucket.id
}

output "devops_s3bucket" {
  description = "stw devops S3 bucket"
  value = aws_s3_bucket.devops_s3bucket.id
}

output "devops_s3bucket_versioning" {
  description = "stw devops S3 bucket versioning"
  value = aws_s3_bucket_versioning.devops_s3bucket_versioning.id
}