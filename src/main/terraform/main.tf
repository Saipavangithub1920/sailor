terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    profile = "default"
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
# ##################### IG############################
# resource "aws_internet_gateway" "sailorig" {
#   vpc_id = aws_vpc.sailorvpc.id

#   tags = {
#     Name = "sailorig"
#   }
# }

# resource "aws_route_table" "sailorrt" {
#   vpc_id = aws_vpc.sailorvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.sailorig.id
#   }

#   tags = {
#     Name = "Public Route Table"
#   }
# }

# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.sailorpubsubnet.id
#   route_table_id = aws_route_table.sailorrt.id
# }
# ######################security_group#################
# resource "aws_security_group" "sailorsg" {
#     vpc_id = aws_vpc.sailorvpc.id
#     ingress {
#         from_port = 22
#         to_port = 22
#         protocol = "TCP"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = -1
#         cidr_blocks = ["0.0.0.0/0"]
#     } 
#     tags = {
#       Name = "sailorsg"
#     }
# }
# #######################Keypair##########################
# resource "aws_key_pair" "sailorkp" {
#     public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpdtcWcl7Qm4zjdK0mvEYwp/zWFQDYHdd4QEfHnCxszd8bARrl3VIVXZMH8NTJPOaKiYvOs/fI3hYu2XaQWPJYgoVDkMcvrkpWN+P6DXXpH1AFRMx2EwLj1CaM9KyMt6D/WCNhzwKSLmqT+lJ2t7jbyk/BGXX3vttI5cWI43WzepJPUyf8xg0nceLBGg04iRmmUrIR0UxxoufyJxvERsIvdmpGsP3My3bGvkbu/aDbQik5Ljc1NBB9PPERHxH7D3jdIoXocqu2/u0MDmAxRiXayFkqgWvfNmqSpAF+BlPFn1TjlFiIJo5IhaKURqtdjPcK133rp6jKUL4XLeG1r69L22XhkMXeO9qmmtsMg9dXjpps1ZHc87qXcB4VveuFjMB4N4Yx2jVo1ugXgqpzRpkZnvAaWV/etFRekQxLabRzwUd4CufMN+5mdZK6fra2D7GMCMs4GwBvNgPsYs6iqziwU7fyBXQuGwrrVjuMXXE4IDpC7Mh239l4mDG1yh4HhuaR9H5/xQUgy1IsOVSripLKpuxYiSV3ykdcLYq6nXKhFTUQOyeVLnlUhbG5/dQY0USmDfS26K1vb2HR/Xk5/qBKuX90yMbflM3mMx/+RT7PtNPSbmvqbXp3GXNlXy6jOXmDa95mefQBoxMZneWIIko/yADnz41X2rDNH1DsgTGPqw== LENOVO@SP"
  
# }
# #######################EC2 Instance#######################
# resource "aws_instance" "sailorec21" {
#     #vpc_id = "aws_vpc.sailorvpc.id"
#     count = 2
#     subnet_id = aws_subnet.sailorpubsubnet.id
#     key_name = aws_key_pair.sailorkp.key_name
#     instance_type = "t2.micro"
#     ami = "ami-0b09627181c8d5778"
#     associate_public_ip_address = true
#     vpc_security_group_ids = [aws_security_group.sailorsg.id]
#     tags = {
#         Name: "speedec2-${count.index + 1}"
#     } 
# }