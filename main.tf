 terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {

  region     = "ap-south-1"  
  access_key = "ASIAUWVAZLGW3ZKT2DCX"
  secret_key = "RTz0+uxaFSWUbHUQEk2ziXAKaiPw5QC/IH9abnRA"
  token      = "IQoJb3JpZ2luX2VjEIr//////////wEaCXVzLXdlc3QtMiJHMEUCICorsj/X+ZEVkpI8Gby0oZE/8nr5kuV6QHYyAxWWA06LAiEAj3S8ZJOX++MKv8X+8j3tN0u8npTR+AjISbFMcVlQItwq8AQIUhABGgwzMjM1MzM0OTQ3MDEiDFkfvkPq35Z+R2tvwirNBPH7uWn0Ncuog59VcXvyGKE6gsCyJu61EvM9XfcPbm7sn8ZpREIy7Gok/S4VBIrOfXFSLVj1JZ9U6Bn+z2GsScSPM/xk3RHumY0YFhFo0fSAsRIhL2aJa/Wi3Al1CqlOtKM12rI9Z75c9vJoGzqNEJalOUFO31+LR1Ln70HCzuYkj6fN91XhJtWASYcR82pMB3xxm6wCyFA8LRTprfPCRUI7M0j65/0X3WYxd5liwEH7cVBc0ql2nfuapvqA66plTJNREvd6C8H9Ah8PSIlxu2Ywa0auHtKc/ex8H6eeyzCNZZXywd3sROwjk4gafvJanjv1cE9oH95FWXwWUUHNNeti5ujYvGjWtMQOUthCrW24A+17x8VPW+xebNdJizVhypZWNG5Q44wRtBN5IGc69sp09UQp08Vzp8/6Rtw9KUWATGHcP5/SRoEp47H6VSFus0/zwf5pclQW53Bs0R/OhK2/8S+E3dveQKkudWHeoRUUxu3IdGc4hvNnjg/bYB26ER3bseJpAcIcfYnOLES3YyyCwbfQwZZ0twzD/TiHlbCkOSoSCQA5Fz/e+o56neNZzlNzoSBWCtRNuRWuF9NgpkcAS4DdVGO48uWkB4KwjXdEZBAnwDThcQ39BWCMg3FfMbgSoMK+uHZW8RZpIeR13RCpe2lhHR3BPMGkrGGr6MijC950ZKNa5LguEP+yz6nQa0qYoXbmsVz169CA8RHi7uZWPlEsq5t9QviKHrqNeRL4exehjpvjwsF7h7EpsIU8Ai96KD82elZdf9EcG60w2IbiywY6oQG1x2uyKmUO+DfS+hn2ZyH6GmlKaG1oxvgns3/Cu2SMVxISbXA/ibwW7kC3zo/Eiuf2wqqW4R9fXVHzVTgX9B3NJAFZVQxHpCtGuDy5pTShlKnoKcEIWx/QHBkx+Q3l06RSeB1dNqt9Stcj9/1Uti3cM0HpWuPq+SzKZCGq1QB/EOUvu+XuiSpMLIIm/N09c84caeiWb26wJlXWYVnBS9z8ww=="

}

# Fetch latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Security Group for SSH
resource "aws_security_group" "ec2_sg" {
  name = "ec2-ssh-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = "pritam-tfe"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "terraform-ec2"
  }
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
