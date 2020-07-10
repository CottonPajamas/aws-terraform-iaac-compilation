# Describes the basic configs - which platform you are using and credentials to use if any
# Best practice to include the version of the provider to use in order to ensure consistency in deployments
provider "aws" {
	access_key 	= "<<specify access_key>>"
	secret_key 	= "<<specify secret_key>>"
	region 		= "<<specify region>>"
	version		= "2.7"
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

# This get and describes the default VPC in the specified region
data "aws_vpc" "default" {
  default = true
}

# Create security group
resource "aws_security_group" "FP_SG" {
  name        = "FP_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Traffic from source IP"
    from_port   = "<<specify port>>"
    to_port     = "<<specify port>>"
    protocol    = "tcp"
    cidr_blocks = ["<<specify whitelisted IPs>>"]
  }

	# This allows all traffic going out
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


# Specifies the resource to provision and its associated configurations
# <<-EOF  ....  EOF are Terraform’s heredoc syntax, which allows you to create multiline strings without having to use \n all over the place.
resource "aws_instance" "testVM001" {
	ami                         = data.aws_ami.amazon-linux-2.id
	associate_public_ip_address = true
	instance_type               = "t2.micro"
	key_name                    = "<<specify key pair name>>"
	user_data										= <<-EOF
															#!/bin/bash
															sudo su
															echo "<<specify whitelisted IPs>>" > /home/ec2-user/whitelisted_ips.txt
															curl https://cottonpajamas.github.io/aws-custom-startup-scripts-ec2/squid/start.sh --output /home/ec2-user/start.sh
															chmod +x /home/ec2-user/start.sh
															. /home/ec2-user/start.sh
															EOF
	security_groups				 			= [aws_security_group.FP_SG.name]   # Note that name and not id is to be used.
}

# Generates out the output once you run "terraform apply".
output "lb_address" {
  value = aws_instance.testVM001.public_dns
}

output "instance_ips" {
  value = [aws_instance.testVM001.*.public_ip]
}
