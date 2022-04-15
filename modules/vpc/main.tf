data "aws_availability_zones" "available" {}

resource "aws_vpc" "tf_vpc" {
  cidr_block = var.cidr
  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "Demo Internet Gateway"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "routes_public" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "Route for Public subnets"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*].id)
  route_table_id = aws_route_table.routes_public.id
  subnet_id      = element(aws_subnet.public[*].id, count.index)
}

resource "aws_eip" "nat" {
  count = length(var.private_subnets_cidr)
  vpc   = true
  tags = {
    Name = "Demo NAT ${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnets_cidr)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index)
  tags = {
    Name = "Demo NAT ${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Private subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "private_subnet" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "Route for Private ${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private[*].id)
  route_table_id = aws_route_table.private_subnet[count.index].id
  subnet_id      = element(aws_subnet.private[*].id, count.index)
}
