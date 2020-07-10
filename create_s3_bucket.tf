# Creates a fully private S3 bucket
# References:
# 	- https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
# 	- https://www.terraform.io/docs/providers/aws/r/s3_bucket_public_access_block.html

provider "aws" {
	access_key 	= "<<specify access_key>>"
	secret_key 	= "<<specify secret_key>>"
	region 		= "<<specify region>>"
	version		= "2.7"
}

# Creating S3 bucket
resource "aws_s3_bucket" "custom_bucket" {
	bucket = "my-custom-s3-terraform-bucket"
	acl	= "private"

	# Enables versioning
	versioning {
		enabled = true
	}

	tags = {
		Name = "my-custom-s3-terraform-bucket"
		Environment = "Dev"
	}
}

# Blocks all public access for our newly created bucket - this can be found under the bucket's 'Permssions' settings
resource "aws_s3_bucket_public_access_block" "example" {
	bucket					= aws_s3_bucket.custom_bucket.id
	block_public_acls			= true
	block_public_policy			= true
	ignore_public_acls			= true
	restrict_public_buckets			= true
}

# Generates output
output "sg_id" {
	value = aws_s3_bucket.custom_bucket.id
}

output "sg_bucket_domain_name" {
	value = aws_s3_bucket.custom_bucket.bucket_domain_name
}
