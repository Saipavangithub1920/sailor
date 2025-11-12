terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    region = "ap-south-1"
}
######################VPC##########################
resource "aws_vpc" "sailorvpc" {
    cidr_block = "10.0.0.0/16" 
    tags = {
        Name = "sailorvpc"
    } 
}
######################SUBNET#######################
resource "aws_subnet" "sailorpubsubnet" {
    vpc_id = aws_vpc.sailorvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name: "sailorpubsubnet"
    } 
}
##################### IG############################
resource "aws_internet_gateway" "sailorig" {
  vpc_id = aws_vpc.sailorvpc.id

  tags = {
    Name = "sailorig"
  }
}

resource "aws_route_table" "sailorrt" {
  vpc_id = aws_vpc.sailorvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sailorig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sailorpubsubnet.id
  route_table_id = aws_route_table.sailorrt.id
}
######################security_group#################
resource "aws_security_group" "sailorsg" {
    vpc_id = aws_vpc.sailorvpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    } 
    tags = {
      Name = "sailorsg"
    }
}

##############Keypair ###################
resource "null_resource" "jenkins_ssh_key" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Generating Jenkins SSH key if not exists..."
      if [ ! -f "./jenkins_key" ]; then
        ssh-keygen -t rsa -b 2048 -f ./jenkins_key -N ""
      fi
    EOT
  }
}

resource "aws_key_pair" "jenkins_key" {
  depends_on = [null_resource.jenkins_ssh_key]
  key_name   = "jenkins-key"
  public_key = file("${path.module}/jenkins_key.pub")
}

#######################EC2 Instance#######################
resource "aws_instance" "sailorec21" {
    #vpc_id = "aws_vpc.sailorvpc.id"
    subnet_id = aws_subnet.sailorpubsubnet.id
    key_name = aws_key_pair.jenkins_key.key_name
    instance_type = "t2.micro"
    ami = "ami-0b09627181c8d5778"
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.sailorsg.id]
    tags = {
        Name: "sailorec21"
    } 
}
