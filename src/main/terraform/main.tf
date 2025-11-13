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
