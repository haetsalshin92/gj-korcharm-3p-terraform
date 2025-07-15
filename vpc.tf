provider "aws" {
  region = "ap-northeast-2"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# ───────────── Public Subnets ─────────────

# React Subnet 1 (2a)
resource "aws_subnet" "public_1a_react" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1a-react"
  }
}

# React Subnet 2 (2c)
resource "aws_subnet" "public_1c_react" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1c-react"
  }
}

# Spring Subnet 1 (2a)
resource "aws_subnet" "public_1a_spring" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1a-spring"
  }
}

# Spring Subnet 2 (2c)
resource "aws_subnet" "public_1c_spring" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1c-spring"
  }
}

# ───────────── Route Table ─────────────

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_1a_react_association" {
  subnet_id      = aws_subnet.public_1a_react.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_1c_react_association" {
  subnet_id      = aws_subnet.public_1c_react.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_1a_spring_association" {
  subnet_id      = aws_subnet.public_1a_spring.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_1c_spring_association" {
  subnet_id      = aws_subnet.public_1c_spring.id
  route_table_id = aws_route_table.public_rt.id
}
