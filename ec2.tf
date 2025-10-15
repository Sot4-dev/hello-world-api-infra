resource "aws_security_group" "app_sg" {
  name = "hello-world-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Allow SSH from anywhre"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "hello-world-sg"
  }
}

data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

resource "aws_instance" "app_server" {
  ami = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name = "terraform-key"

  user_data = <<-EOF
              #!/bin/bash

              aws ecr get-login-password -region ${var.primary_region} | docker login --username AWS password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.primary_region}.amazonaws.com
              docker run -d -p 80:5000 ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.primary_region}.amazonaws.com/hello-world-api:latest
              EOF
  tags = {
    Name = "hello-world-app-serever"
  }
}