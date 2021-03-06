## AWS IAAC configuration files using Terraform
Compilation of useful terraform infrastructure as a code deployment files for Amazon Web Services.

<br>

### Contents
1. Basics
    - [x] Usefult tips : &nbsp;&nbsp;[useful-tips.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/useful-tips.tf) &nbsp;&nbsp;
    - [x] Creating S3 bucket : &nbsp;&nbsp;[create_s3_bucket.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/create_s3_bucket.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/create_s3_bucket.tf)
    - [x] Creating a security group : &nbsp;&nbsp;[create_security_group.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/create_security_group.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/create_security_group.tf)
    - [x] Creating a VPC with a single public and private subnet : &nbsp;&nbsp;[create_simple_vpc.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/create_simple_vpc.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/create_simple_vpc.tf)

<br>

2. Deploy a Squid Forward Proxy server
    - [x] Deploy to default VPC : &nbsp;&nbsp;[squid_proxy_server_default_vpc.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/squid_proxy_server_default_vpc.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/squid_proxy_server_default_vpc.tf)
    - [x] Deploy to existing VPC : &nbsp;&nbsp;[
squid_proxy_server_existing_vpc.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/squid_proxy_server_existing_vpc.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/squid_proxy_server_existing_vpc.tf)
    - [x] Deploy with custom VPC : &nbsp;&nbsp;[squid_proxy_server_custom_vpc.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/squid_proxy_server_custom_vpc.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/squid_proxy_server_custom_vpc.tf)

<br>

3. Deploy a private Wireguard VPN server
    - [ ] Deploy with custom VPC : &nbsp;&nbsp;[squid_proxy_server_custom_vpc.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/squid_proxy_server_custom_vpc.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/squid_proxy_server_custom_vpc.tf)

<br>

4. Deploy mockpass server
    - [x] Deploy with custom VPC : &nbsp;&nbsp;[mockpass_server.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/mockpass_server.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/mockpass_server.tf)
    - *For more info, please refer to https://github.com/opengovsg/mockpass*

<br>

5. Deploy bastion host in a public subnet and a private server in a private subnet with custom VPC
    - [ ] Deploy bastion host and a private server : &nbsp;&nbsp;[bastion_and_private_server.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/bastion_and_private_server.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/bastion_and_private_server.tf)
    
<br>

6. Deploy a serverless REST API using API Gateway and AWS Lambda
    - [ ] Deploy without VPC : &nbsp;&nbsp;[serverless_api_without_vpc.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/serverless_api_without_vpc.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/serverless_api_without_vpc.tf)
    - [ ] Deploy with custom VPC : &nbsp;&nbsp;[serverless_api_with_custom_vpc.tf](https://github.com/CottonPajamas/aws-terraform-iaac-compilation/blob/master/serverless_api_with_custom_vpc.tf) &nbsp;&nbsp;|&nbsp;&nbsp; [raw file](https://raw.githubusercontent.com/CottonPajamas/aws-terraform-iaac-compilation/master/serverless_api_with_custom_vpc.tf)

