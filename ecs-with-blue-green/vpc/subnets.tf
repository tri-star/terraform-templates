resource "aws_subnet" "sn1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-sn1"
  }
}

resource "aws_subnet" "sn2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-sn2"
  }
}
