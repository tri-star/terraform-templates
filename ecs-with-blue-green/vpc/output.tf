
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  description = "サブネットの一覧"
  value = [
    aws_subnet.sn1.id,
    aws_subnet.sn2.id,
  ]
}
