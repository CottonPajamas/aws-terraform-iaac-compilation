# Creating a custom VPC with a single private and public subnet.
# References:
#	- https://medium.com/@brad.simonin/create-an-aws-vpc-and-subnet-using-terraform-d3bddcbbcb6
# 	- https://www.terraform.io/docs/providers/aws/r/vpc.html
#	- https://www.terraform.io/docs/providers/aws/r/subnet.html
#	- https://www.terraform.io/docs/providers/aws/r/route_table.html
#	- https://www.terraform.io/docs/providers/aws/r/route.html
#	- https://www.terraform.io/docs/providers/aws/r/route_table_association.html

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
	destination_cidr_block = "0.0.0.0/0"		# This meant that any IP can come in and hit our public servers residing in our public subnet
	gateway_id             = aws_internet_gateway.custom_vpc_igw.id
}

# Associate the custom public Route Table with the public subnet
resource "aws_route_table_association" "Public_RT_association" {
	subnet_id      = aws_subnet.public_subnet_01.id
	route_table_id = aws_route_table.custom_public_rt.id
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
