# Launch Template
resource "aws_launch_template" "spring_lt" {
  name_prefix   = "lt-spring-"
  image_id      = "ami-00831e34ffc1077e4"
  instance_type = "t2.micro"
  key_name      = "gj-test2"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg_spring.id]
  }

user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
usermod -aG docker ec2-user

echo "${var.gh_token}" | docker login ghcr.io -u ${var.gh_username} --password-stdin

docker pull ghcr.io/haetsalshin92/springboot-app:latest
docker run -d \
  -v /home/ec2-user/app/application.properties:/app/application.properties \
  -p 8080:8080 \
  ghcr.io/haetsalshin92/springboot-app \
  java -jar app.jar --spring.config.location=file:/app/application.properties
EOF
)


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "springboot-instance"
    }
  }
}

# Target Group (port 8080)
resource "aws_lb_target_group" "spring_tg" {
  name     = "tg-spring"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/api/main" 
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# ALB
resource "aws_lb" "spring_alb" {
  name               = "alb-spring"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_1a_spring.id,
    aws_subnet.public_1c_spring.id,
  ]
  security_groups = [aws_security_group.sg_spring.id]

  tags = {
    Name = "alb-spring"
  }
}

# Listener
resource "aws_lb_listener" "spring_listener" {
  load_balancer_arn = aws_lb.spring_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.spring_tg.arn
  }
}


resource "aws_instance" "spring_2a" {
  ami                         = "ami-00831e34ffc1077e4"
  instance_type               = "t2.micro"
  key_name                    = "gj-test2"
  subnet_id                   = aws_subnet.public_1a_spring.id
  vpc_security_group_ids      = [aws_security_group.sg_spring.id]
  associate_public_ip_address = true

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
usermod -aG docker ec2-user

echo "${var.gh_token}" | docker login ghcr.io -u ${var.gh_username} --password-stdin

docker pull ghcr.io/haetsalshin92/springboot-app:latest
docker run -d \
  -v /home/ec2-user/app/application.properties:/app/application.properties \
  -p 8080:8080 \
  ghcr.io/haetsalshin92/springboot-app \
  java -jar app.jar --spring.config.location=file:/app/application.properties
EOF
  )

  tags = {
    Name = "springboot-instance-2a"
  }
}

resource "aws_instance" "spring_2c" {
  ami                         = "ami-00831e34ffc1077e4"
  instance_type               = "t2.micro"
  key_name                    = "gj-test2"
  subnet_id                   = aws_subnet.public_1c_spring.id
  vpc_security_group_ids      = [aws_security_group.sg_spring.id]
  associate_public_ip_address = true

    user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
usermod -aG docker ec2-user

echo "${var.gh_token}" | docker login ghcr.io -u ${var.gh_username} --password-stdin

docker pull ghcr.io/haetsalshin92/springboot-app:latest
docker run -d \
  -v /home/ec2-user/app/application.properties:/app/application.properties \
  -p 8080:8080 \
  ghcr.io/haetsalshin92/springboot-app \
  java -jar app.jar --spring.config.location=file:/app/application.properties
EOF
  )
  tags = {
    Name = "springboot-instance-2c"
  }
}