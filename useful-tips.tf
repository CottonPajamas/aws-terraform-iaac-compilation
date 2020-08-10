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
