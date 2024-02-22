resource "aws_subnet" "public-subnet1" {
  cidr_block              = var.public_subnet_cidr1
  vpc_id                  = aws_vpc.visitor-eks-vpc.id
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "visitor-eks-Public-Subnet1-${random_string.suffix.result}"
  }
}

resource "aws_subnet" "public-subnet2" {
  cidr_block              = var.public_subnet_cidr2
  vpc_id                  = aws_vpc.visitor-eks-vpc.id
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "visitor-eks-Public-Subnet2-${random_string.suffix.result}"
  }
}

resource "aws_route_table_association" "public-subnet1" {
  route_table_id = aws_route_table.public-route.id
  subnet_id      = aws_subnet.public-subnet1.id
}

resource "aws_route_table_association" "public-subnet2" {
  route_table_id = aws_route_table.public-route.id
  subnet_id      = aws_subnet.public-subnet2.id
}
