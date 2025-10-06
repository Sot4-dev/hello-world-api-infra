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

data "aws_ami" "ecs_optimized_linux_2" {
    most_recent = true
    owners = [ "amazon" ]

    filter {
      name = "name"
      values = [ "amzn2-ami-hvm-*-x86_64-ebs" ]
    }
}

resource "aws_instance" "app.server" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name = "terraform-key"

  tags = {
    Name = "hello-world-app-serever"
  }
}