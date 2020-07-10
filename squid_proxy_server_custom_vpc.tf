# Creating a squid forward proxy server within a custom VPC.

provider "aws" {
	access_key 	= "<<specify access_key>>"
	secret_key 	= "<<specify secret_key>>"
	region 		= "<<specify region>>"
	version		= "2.7"
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

# Create private subnet
resource "aws_subnet" "private_subnet_01" {
	vpc_id                  = aws_vpc.custom_vpc.id
	cidr_block              = "10.0.1.0/24"
	map_public_ip_on_launch = false
	availability_zone       = "<<specify az>>"
	tags = {
		Name = "10.0.1.0/24 - private subnet 01"
	}
}

# Create public subnet
resource "aws_subnet" "public_subnet_01" {
	vpc_id                  = aws_vpc.custom_vpc.id
	cidr_block              = "10.0.2.0/24"
	map_public_ip_on_launch = true
	availability_zone       = "<<specify az>>"
	tags = {
		Name = "10.0.2.0/24 - public subnet 01"
	}
}

# Create Internet Gateway (IGW)
resource "aws_internet_gateway" "custom_vpc_igw" {
	vpc_id	= aws_vpc.custom_vpc.id
	tags 	= {
		Name = "My custom VPC Internet Gateway"
	}
}

# Create custom Route Table (RT) for our public subnet - Our private subnet will use the default RT that AWS generates for us
resource "aws_route_table" "custom_public_rt" {
	vpc_id 	= aws_vpc.custom_vpc.id
	tags 	= {
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

# Create security group for the forward proxy instance
resource "aws_security_group" "FP_SG" {
	name        = "FP_SG"
	description = "Allow TLS inbound traffic"
	vpc_id      = aws_vpc.custom_vpc.id

	ingress {
		description = "Traffic from source IP"
		from_port   = "<<specify port>>"
		to_port     = "<<specify port>>"
		protocol    = "tcp"
		cidr_blocks = ["<<specify whitelisted IPs>>"]
	}

	# This allows all outbound traffic
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "FP_SG"
	}
}

# This describes the AMI to use - here we only want to use the latest Amazon Linux AMI
data "aws_ami" "amazon-linux-2" {
	most_recent = true
	owners = ["amazon"]
	filter {
		name = "owner-alias"
		values = ["amazon"]
	}
	filter {
		name = "name"
		values = ["amzn2-ami-hvm*"]
	}
}

# Specifies the resource to provision and its associated configurations
resource "aws_instance" "testVM001" {
	ami				= data.aws_ami.amazon-linux-2.id
	associate_public_ip_address	= true
	instance_type			= "t2.micro"
	key_name			= "<<specify key pair name>>"
	user_data			= <<-EOF
						#!/bin/bash
						sudo su
						echo "<<specify whitelisted IPs>>" > /home/ec2-user/whitelisted_ips.txt
						curl https://cottonpajamas.github.io/aws-custom-startup-scripts-ec2/squid/start.sh --output /home/ec2-user/start.sh
						chmod +x /home/ec2-user/start.sh
						. /home/ec2-user/start.sh
					EOF
	subnet_id			= aws_subnet.public_subnet_01.id
	vpc_security_group_ids 		= [aws_security_group.FP_SG.id]		# Note that id and not name is to be used here.
}

# Generates output
output "vpc_id" {
	value = aws_vpc.custom_vpc.id
}

output "private_subnet_id" {
	value = aws_subnet.private_subnet_01.id
}

output "public_subnet_id" {
	value = aws_subnet.public_subnet_01.id
}

output "vm_dns" {
  value = aws_instance.testVM001.public_dns
}

output "vm_ip" {
  value = [aws_instance.testVM001.*.public_ip]
}
