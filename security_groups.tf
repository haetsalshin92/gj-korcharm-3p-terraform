# React EC2 보안 그룹
resource "aws_security_group" "sg_react" {
  name        = "react-sg"
  description = "Allow HTTP for React"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 혹은 ALB CIDR로 제한 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "react-sg"
  }
}

# SpringBoot EC2 보안 그룹
resource "aws_security_group" "sg_spring" {
  name        = "spring-sg"
  description = "Allow HTTP for SpringBoot"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from React ALB or public"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 나중에 GitHub Webhook IP로 제한 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "spring-sg"
  }
}

# MongoDB
resource "aws_security_group" "sg_mongodb" {
  name        = "mongodb-sg"
  description = "Allow MongoDB from SpringBoot"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow MongoDB from SpringBoot EC2"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_spring.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mongodb-sg"
  }
}
