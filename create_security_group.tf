# Creates a single security group in the default AWS VPC
# References:
# 	- https://www.terraform.io/docs/providers/aws/r/security_group.html

provider "aws" {
	access_key 	= "<<specify access_key>>"
	secret_key 	= "<<specify secret_key>>"
	region 		= "<<specify region>>"
	version		= "2.7"
}

# This get and describes the default VPC in the specified region
data "aws_vpc" "default" {
	default = true
}

# Create security group (we are creating it inside the default VPC)
resource "aws_security_group" "custom_sg" {
	name        = "custom_sg"
	description = "Allow TLS inbound traffic"
	vpc_id      = data.aws_vpc.default.id

	ingress {
		description = "Traffic from source IP"
		from_port   = "<<specify port>>"
		to_port     = "<<specify port>>"
		protocol    = "tcp"
		cidr_blocks = ["<<specify CIDR blocks>>"]
	}

	# This allows all outbound traffic
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "custom_sg"
	}
}

# Generates output
output "sg_id" {
	value = aws_security_group.custom_sg.id
}

output "sg_name" {
	value = aws_security_group.custom_sg.name
}
