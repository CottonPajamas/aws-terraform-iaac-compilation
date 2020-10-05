# 1. Using random resource name
# Ref: https://advancedweb.hu/how-to-use-unique-resource-names-with-terraform/#random-id
resource "random_id" "id" {
	  byte_length = 8
}

resource "aws_instance" "server" {
  name = "instance-${random_id.id.hex}"
  ami           = "<<specify ami>>"
  instance_type = "t2.nano"
}


# 2. Creating multiple resources
# Ref: https://www.bogotobogo.com/DevOps/Terraform/Terraform-Introduction-AWS-loops.php#for
variable "qty" {
  description = "number of api instances"
  default = 3
}

resource "aws_instance" "server" {
  count = var.instances
  ami           = "<<specify ami>>"
  instance_type = "t2.nano"
  tags = {
    Name = "Server ${count.index}"
  }
}


# 3. Using the latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


# 4. Using the latest Ubuntu 18.04 Bionic AMI
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
