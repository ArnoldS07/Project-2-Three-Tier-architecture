resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Public subnets (for ALB + NAT)
resource "aws_subnet" "public" {
  for_each = { for idx, az in toset(var.azs) : idx => az }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, tonumber(each.key)) # 10.1.0.0/20, 10.1.16.0/20
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-${each.value}"
  }
}

# Private app subnets
resource "aws_subnet" "private_app" {
  for_each = { for idx, az in toset(var.azs) : idx => az }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, tonumber(each.key) + 2) # next blocks
  availability_zone = each.value

  tags = {
    Name = "${var.name}-private-app-${each.value}"
  }
}

# Private db subnets
resource "aws_subnet" "private_db" {
  for_each = { for idx, az in var.azs : idx => az }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, each.key + 4) # now each.key is numeric
  availability_zone = each.value
}

  tags = {
    Name = "${var.name}-private-db-${each.value}"
  }
}

# NAT: single NAT for cost-efficiency
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = {
    Name = "${var.name}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name}-private-app-rt"
  }
}

resource "aws_route_table_association" "private_app" {
  for_each       = aws_subnet.private_app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id
  # no internet route for DB

  tags = {
    Name = "${var.name}-private-db-rt"
  }
}

resource "aws_route_table_association" "private_db" {
  for_each       = aws_subnet.private_db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}
