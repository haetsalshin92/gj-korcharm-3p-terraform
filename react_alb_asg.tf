# Launch Template
resource "aws_launch_template" "react_lt" {
  name_prefix   = "lt-react-"
  image_id      = "ami-03ff09c4b716e6425"
  instance_type = "t2.micro"
  key_name      = "gj-test2"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg_react.id]
  }
    user_data = base64encode(<<EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    usermod -aG docker ec2-user

    # Docker login to GHCR
    echo "${var.gh_token}" | docker login ghcr.io -u ${var.gh_username} --password-stdin

    # Pull and run container
    docker pull ghcr.io/haetsalshin92/react-app:latest
    docker run -d -p 8080:8080 \
        ghcr.io/haetsalshin92/springboot-app:latest
    EOF
    )


    tag_specifications {
        resource_type = "instance"
        tags = {
        Name = "react-instance"
        }
    }
    }

# Target Group
resource "aws_lb_target_group" "react_tg" {
  name     = "tg-react"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# ALB
resource "aws_lb" "react_alb" {
  name               = "alb-react"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_1a_react.id,
    aws_subnet.public_1c_react.id,
  ]
  security_groups = [aws_security_group.sg_react.id]

  tags = {
    Name = "alb-react"
  }
}

# Listener
resource "aws_lb_listener" "react_listener" {
  load_balancer_arn = aws_lb.react_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.react_tg.arn
  }
}

resource "aws_instance" "react_2a" {
  ami                         = "ami-03ff09c4b716e6425"
  instance_type               = "t2.micro"
  key_name                    = "gj-test2"
  subnet_id                   = aws_subnet.public_1a_react.id
  vpc_security_group_ids      = [aws_security_group.sg_react.id]
  associate_public_ip_address = true

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
usermod -aG docker ec2-user

echo "${var.gh_token}" | docker login ghcr.io -u ${var.gh_username} --password-stdin

docker pull ghcr.io/haetsalshin92/react-app:latest
docker run -d -p 80:80 ghcr.io/haetsalshin92/react-app:latest
EOF
  )

  tags = {
    Name = "react-instance-2a"
  }
}

resource "aws_instance" "react_2c" {
  ami                         = "ami-03ff09c4b716e6425"
  instance_type               = "t2.micro"
  key_name                    = "gj-test2"
  subnet_id                   = aws_subnet.public_1c_react.id
  vpc_security_group_ids      = [aws_security_group.sg_react.id]
  associate_public_ip_address = true

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
usermod -aG docker ec2-user

echo "${var.gh_token}" | docker login ghcr.io -u ${var.gh_username} --password-stdin

docker pull ghcr.io/haetsalshin92/react-app:latest
docker run -d -p 80:80 ghcr.io/haetsalshin92/react-app:latest
EOF
  )
  tags = {
    Name = "react-instance-2c"
  }
}