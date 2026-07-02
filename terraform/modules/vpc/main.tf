resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_public1
  availability_zone = var.az_1

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_public2
  availability_zone = var.az_2

  tags = {
    Name = "public-subnet-2"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}