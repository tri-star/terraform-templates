resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-public-rt"
  }
}


resource "aws_route_table_association" "sn1" {
  subnet_id      = aws_subnet.sn1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "sn2" {
  subnet_id      = aws_subnet.sn2.id
  route_table_id = aws_route_table.public_rt.id
}
