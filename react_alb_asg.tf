# Launch Template
resource "aws_launch_template" "react_lt" {
  name_prefix   = "lt-react-"
  image_id      = "ami-03ff09c4b716e6425"
  instance_type = "t2.micro"
  key_name      = "gj-test2.pem"

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
        -e SPRING_DATA_MONGODB_HOST="${var.mongodb_host}" \
        -e SPRING_DATA_MONGODB_PORT="${var.mongodb_port}" \
        -e SPRING_DATA_MONGODB_DATABASE="${var.mongodb_database}" \
        -e SPRING_DATA_MONGODB_USERNAME="${var.mongodb_username}" \
        -e SPRING_DATA_MONGODB_PASSWORD="${var.mongodb_password}" \
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

# Auto Scaling Group
resource "aws_autoscaling_group" "react_asg" {
  name                      = "asg-react"
  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 2
  vpc_zone_identifier       = [
    aws_subnet.public_1a_react.id,
    aws_subnet.public_1c_react.id,
  ]
  launch_template {
    id      = aws_launch_template.react_lt.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.react_tg.arn]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "react-instance"
    propagate_at_launch = true
  }
}
