## DEPLOY DOCKER FILE IN AWS EC2 UING TERRAFORM

This project is about installing deployoming a slush.sh file and installing docker once an Ec2 instance is provisioned and lunch with WAWs infrastructure 

Projects Requirements First download and install the terraform using this link As a first step, install terraform (see: https://www.terraform.io/downloads)) 
and select your machine version if its windows and if its mac you can select accordingly and install the requirements:

### To check if terraform was installed
$ terraform --version

Download and run the AWS CLI MSI installer for Windows (64-bit) and add the IAM user credentails gotten from AWS the secret_key and the access_key

https://awscli.amazonaws.com/AWSCLIV2.msi

### Terraform Access Provisioning and Docker requirements for this project:
I created the main.tf file and insert the follwing code snippeets below 

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

Then inside the main.tf file in created the ec2 instance respurce and then addedd the security group called "docker" for that resource every other 
components like ingress and egree rules,key name of the key pair generated with AWs called "devopskey",instance type called "t2.micro",
while userdata will allow the file slush.sh bash script to be run
as shown in the code snippest below

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
  
  Next the bash script will runan update , run the terraform, docker, docker-compose before
  allowing the source code to be run as shown below in the snippets
 
sudo apt-get update -y &&

sudo apt-get install -y \

sudo yum install -y yum-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

sudo yum -y install terraform

sudo touch ~/.bashrc

sudo terraform -install-autocomplete

apt-transport-https \

ca-certificates \

curl \
gnupg-agent \

software-properties-common &&

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&

sudo apt-get update -y &&

sudo sudo apt-get install docker-ce docker-ce-cli containerd.io -y &&

sudo usermod -aG docker ubuntu

sudo service docker start

sudo chkconfig docker on

sudo yum install -y git

sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl enable docker
