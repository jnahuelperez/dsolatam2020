#--------------------------------------------------------------------------------
# PROVIDER
#--------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

#--------------------------------------------------------------------------------
# DEV
#--------------------------------------------------------------------------------

resource "aws_instance" "mt-splunk" {
  ami                         = "ami-06cf02a98a61f9f5e"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.test.id
  key_name                    = "NPerez_Key"
  ebs_optimized               = false
  monitoring                  = false
  associate_public_ip_address = true
  security_groups = [
    aws_security_group.splunk.id
    ]

  # root_block_device {
  #   volume_type           = "gp2"
  #   volume_size           = 10
  #   delete_on_termination = true
  # }

  tags = {
    Owner = "DSOLatam2020"
    Type = "dev"
    Name = "splunk-dev"
  }
}

resource "aws_vpc" "test" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Owner = "DSOLatam2020"
    Type = "dev"
    Name = "vpc-dev"
  }
}

resource "aws_subnet" "test" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Owner = "DSOLatam2020"
    Type = "dev"
    Name = "subnet-dev"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test.id

  tags = {
    Owner = "DSOLatam2020"
    Type = "dev"
    Name = "subnet-dev"
  }
}

resource "aws_security_group" "splunk" {
  name        = "splunk"
  description = "test-splunk"
  vpc_id      = aws_vpc.test.id
}


resource "aws_security_group_rule" "splunk_ingress_WEB" {
  type        = "ingress"
  from_port   = 8000
  to_port     = 8000
  protocol    = "tcp"
  description = "Allow ingress 8000 from BA office"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk.id
}

resource "aws_security_group_rule" "splunk_ingress_SSH" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  description = "Allow SSH to bad guys"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.splunk.id
}

terraform {
  backend "s3" {
    bucket = "dsolatam2020"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}