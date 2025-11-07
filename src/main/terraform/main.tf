terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    # profile = "default"
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
#######################Keypair##########################
resource "aws_key_pair" "sailorkp" {
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC23zykzJv1/S+B/MVWGACpw89dr16K6FTYGT7eIBG/sdkslYkHhilaANGMsp3j88NSHpmoCKYTCUiMWYXEl4r+5bQ+oeUQsdgKZudE0k/vskaGEnvrCtJcX0MM1BX0BLJDIvupjNhbZ3n7CdRLVdR6VjiBpE31Ee5e6gRWLGrK0eS7uo26LGA0CRrbvf9vBGElVrhtL4upWZczECQd7vcjLkg4ZUxWdRan6XXzH8KmaSoAVIR3UMlooSM/3jOn5WR+WkgI+cB7UPfKaCL5fvzgdURbLMMfmV/mlc14MwixIetTcTOZJXexxCYtHoNpNC4uRNQ8CBBhvf5aoABnIBygtn/ADkc08vSf64GUjZ2C+TwnIpwHf4o23DsQXWpeNtd1durXMHFmt35LI6QsI92Qz/IguMDNLJAyifvx6bVxS3ij6iSBifP7Pwqiwu5H/fHqQpalonHqd/Uu3oiLSI20C+dD2u7xTdoWcOCzwwpSHi/fsVZ/eUed2LiwmP2vY47uqmxvyo7QRHTR0KkFBsH0vs3M7W6QRrDE5fyqZ3jG8vPweS/ISbeFjK4NcPt9XFXEFygdbP+n5yNde7it9JMODbcWeOqtemS/H7m4dP8ExbttyhHmfaeMPU9Q6STbWWUgex/fUHGB3slGN/bYVy4XNKZMYiJdxQ6L0RqXn0j/rQ== LENOVO@SP"
  
}
#######################EC2 Instance#######################
resource "aws_instance" "sailorec21" {
    #vpc_id = "aws_vpc.sailorvpc.id"
    # count = 2
    subnet_id = aws_subnet.sailorpubsubnet.id
    key_name = aws_key_pair.sailorkp.key_name
    instance_type = "t2.micro"
    ami = "ami-0b09627181c8d5778"
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.sailorsg.id]
    # tags = {
    #     Name: "speedec2-${count.index + 1}"
    # } 
}