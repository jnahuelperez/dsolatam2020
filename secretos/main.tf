terraform {
    required_version = ">= 0.11.8"
}

provider "vault" {
    address = "http://127.0.0.1:8200"
    skip_tls_verify = true
}

data "vault_aws_access_credentials" "aws_creds" {
    backend = "aws"
    role = "my-role"
}

provider "aws"{
    access_key = data.vault_aws_access_credentials.aws_creds.access_key
    secret_key = data.vault_aws_access_credentials.aws_creds.secret_key
    region = "us-east-1"
}

resource "aws_instance" "splunk-prod" {
  ami                         = "ami-06cf02a98a61f9f5e"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-123456"
  key_name                    = "NPerez_Key"
  ebs_optimized               = false
  monitoring                  = false
  associate_public_ip_address = true
  # security_groups = [
  #   aws_security_group.splunk-prod.id
  #   ]
    
  tags = {
    Owner = "DSOLatam2020"
    Type = "prod"
    Name = "splunk-prod"
  }
}