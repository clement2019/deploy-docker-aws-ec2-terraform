terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "myaws"
  region  = "eu-west-2"
}

resource "aws_instance" "app_server" {
  ami             = "ami-0a244485e2e4ffd03"
  instance_type   = "t2.micro"
  key_name        = "devopskey"
  user_data       = file("file.sh")
  #security_groups = ["Docker"]
 vpc_security_group_ids = ["${aws_security_group.Docker.id}"]
  tags = {
    Name = "server-machine"
  }
}

resource "aws_security_group" "Docker" {
 ingress {

    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"


  }

  ingress {

    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"


  }

  egress {

    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"


  }
  tags = {

    Name = "docker-Firewall"
  }

}