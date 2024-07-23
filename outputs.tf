output "stw_vpc_id" {
  description = "stw subnet private 1"
  value       = aws_vpc.stw_vpc.id
}

output "stw_subnet_private_1_id" {
  description = "stw subnet private 1"
  value       = aws_subnet.stw_subnet_private_1.id
}

output "stw_subnet_private_2_id" {
  description = "stw subnet private 2"
  value       = aws_subnet.stw_subnet_private_2.id
}

output "stw_subnet_public_1_id" {
  description = "stw subnet public 1"
  value       = aws_subnet.stw_subnet_public_1.id
}

output "stw_subnet_public_2_id" {
  description = "stw subnet public 2"
  value       = aws_subnet.stw_subnet_public_2.id
}
