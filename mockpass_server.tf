provider "aws" {
  access_key = "<<specify access_key>>"
  secret_key = "<<specify secret_key>>"
  region     = "<<specify region>>"
  version    = "3.9.0"
}

variable "my_ip" {
  type    = string
  default = "<<specify whitelisted IP>>"
}

# Create VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Custom VPC"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1b"
  tags = {
    Name = "10.0.2.0/24 - public subnet 01"
  }
}

# Create Internet Gateway (IGW)
resource "aws_internet_gateway" "custom_vpc_igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "My custom VPC Internet Gateway"
  }
}

# Create custom Route Table (RT) for our public subnet - this will be different from the default RT that AWS auto-generates
resource "aws_route_table" "custom_public_rt" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "Custom public route table"
  }
}

# Create route to enable internet access
resource "aws_route" "Enable_internet_access" {
  route_table_id         = aws_route_table.custom_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.custom_vpc_igw.id
}

# Associate the custom public Route Table with the public subnet
resource "aws_route_table_association" "Public_RT_association" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = aws_route_table.custom_public_rt.id
}

# Create security group for mockpass instance
resource "aws_security_group" "mockpass_sg" {
  name        = "MOCKPASS_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "Traffic from source IP"
    from_port   = "5156"
    to_port     = "5156"
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    description = "SSH from source IP"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  # This allows all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MOCKPASS_SG"
  }
}

# This describes the AMI to use - here we only want to use the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Specifies the resource to provision and its associated configurations
resource "aws_instance" "mockpass_vm" {
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "<<specify key pair name>>"
  user_data                   = <<-EOF
									#!/bin/bash
									
									# Prep required packages
									sudo su
									cd /home/ubuntu/
									apt-get update -y
									apt-get install curl
									curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
									apt-get install nodejs -y
									# Optional: Update npm
									# npm install npm -g
									
									# Set mockpass env variables
									export MOCKPASS_PORT=5156
									export MOCKPASS_NRIC=S8979373D
									export MOCKPASS_UEN=123456789A
									export SHOW_LOGIN_PAGE=true # Optional, defaults to `false`

									# Disable signing/encryption (Optional, by default `true`)
									export SIGN_ASSERTION=false
									export ENCRYPT_ASSERTION=false
									export SIGN_RESPONSE=false
									export RESOLVE_ARTIFACT_REQUEST_SIGNED=false

									# Encrypt payloads returned by /myinfo/*/{person, person-basic},
									# equivalent to MyInfo Auth Level L2 (testing and production)
									export ENCRYPT_MYINFO=false

									# If specified, will verify token provided in Authorization header
									# for requests to /myinfo/*/token
									export SERVICE_PROVIDER_MYINFO_SECRET=secret
									
									# Install mockpass
									npm install @opengovsg/mockpass -y
									
									# Run mockpass
									npx mockpass </dev/null &>/dev/null
								EOF
  subnet_id                   = aws_subnet.public_subnet_01.id
  vpc_security_group_ids      = [aws_security_group.mockpass_sg.id]
}

# Generates output
output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet_01.id
}

output "vm_dns" {
  value = aws_instance.mockpass_vm.public_dns
}

output "vm_ip" {
  value = aws_instance.mockpass_vm.public_ip
}
