resource "aws_instance" "ubuntu" {
  ami           = var.aws_ami
  count         = var.instance_count
  instance_type = "t3.micro"
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "udacity-web"
  }
}

resource "aws_security_group" "ec2_sg" {
    name    = "ec2_sg"
    vpc_id  = var.vpc_id

  tags = {
    Name = "ec2_sg"
  }
}