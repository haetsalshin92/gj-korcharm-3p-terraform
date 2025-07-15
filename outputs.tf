output "react_alb_dns" {
  description = "Public DNS of React ALB"
  value       = aws_lb.react_alb.dns_name
}

output "spring_alb_dns" {
  description = "Public DNS of Spring Boot ALB"
  value       = aws_lb.spring_alb.dns_name
}

output "public_react_subnet_ids" {
  description = "Public React Subnet IDs"
  value = [
    aws_subnet.public_1a_react.id,
    aws_subnet.public_1c_react.id
  ]
}

output "public_spring_subnet_ids" {
  description = "Public SpringBoot Subnet IDs"
  value = [
    aws_subnet.public_1a_spring.id,
    aws_subnet.public_1c_spring.id
  ]
}

output "security_group_react" {
  description = "React EC2 Security Group ID"
  value       = aws_security_group.sg_react.id
}

output "security_group_spring" {
  description = "SpringBoot EC2 Security Group ID"
  value       = aws_security_group.sg_spring.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}
