output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}


output "public_subnet_1_id" {
  description = "Public subnet 1 ID"
  value = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "Public subnet 2 ID"
  value = aws_subnet.public_2.id

}

output "public_subnet_ids" {
  description = "Public subnet ID"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

}

output "internet_gateway_id" {
  description = "Ineternet Gateway ID"
  value = aws_internet_gateway.gw.id

}

output "public_route_table_id" {
  description = "Public route table"
  value = aws_route_table.public_rt.id

}

