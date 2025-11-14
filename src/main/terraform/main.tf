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
##################PUBSN###########################
resource "aws_subnet" "sailorpubsn" {
  vpc_id = aws_vpc.sailorvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "sailorpubsn"
  }
}
##################IG##########################
resource "aws_internet_gateway" "sailorig" {
    vpc_id = aws_vpc.sailorvpc.id
    tags = {
      Name = "sailorig"
    }
}
######################RT######################
resource "aws_route_table" "sailorrt" {
    vpc_id = aws_vpc.sailorvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sailorig.id
    }
    tags = {
      Name = "sailor publicrt"
    }
}
resource "aws_route_table_association" "sailorrtass" {
    subnet_id = aws_subnet.sailorpubsn.id
    route_table_id = aws_route_table.sailorrt.id 
}

