resource "aws_instance" "mongodb" {
  ami                         = "ami-0e770019ca3d79961" 
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1a_mongo.id
  vpc_security_group_ids      = [aws_security_group.sg_mongodb.id]
  associate_public_ip_address = false 

  tags = {
    Name = "mongodb"
  }
}