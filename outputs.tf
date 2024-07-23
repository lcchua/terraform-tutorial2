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
