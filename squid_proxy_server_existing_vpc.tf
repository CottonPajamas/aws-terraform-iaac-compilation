# Describes the basic configs - which platform you are using and credentials to use if any
# Best practice to include the version of the provider to use in order to ensure consistency in deployments
provider "aws" {
	access_key 	= "<<specify access_key>>"
	secret_key 	= "<<specify secret_key>>"
	region 		= "<<specify region>>"
	version		= "2.7"
}

# An example of using variables in a terraform configuration file
variable "custom_subnet" {
  description = "Public subnet - custom VPC"
  default = "<<specify Subnet ID>>"
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
# <<-EOF  ....  EOF are Terraform’s heredoc syntax, which allows you to create multiline strings without having to use \n all over the place.
resource "aws_instance" "testVM001" {
	ami                         = data.aws_ami.amazon-linux-2.id
	associate_public_ip_address = true
	instance_type               = "t2.micro"
	key_name                    = "<<specify key pair name>>"
	user_data					= <<-EOF
								#!/bin/bash
								sudo su
								echo "<<specify whitelisted IPs>>" > /home/ec2-user/whitelisted_ips.txt
								curl https://cottonpajamas.github.io/aws-custom-startup-scripts-ec2/squid/start.sh --output /home/ec2-user/start.sh
								chmod +x /home/ec2-user/start.sh
								. /home/ec2-user/start.sh
								EOF
	subnet_id 					= var.custom_subnet
	vpc_security_group_ids 		= ["<<specify security group ID>>"]
}

# Generates out the output once you run "terraform apply".
output "lb_address" {
  value = aws_instance.testVM001.public_dns
}

output "instance_ips" {
  value = [aws_instance.testVM001.*.public_ip]
}
