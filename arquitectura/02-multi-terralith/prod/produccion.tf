#--------------------------------------------------------------------------------
# prod
#--------------------------------------------------------------------------------

resource "aws_instance" "splunk-prod" {
  ami                         = "ami-06cf02a98a61f9f5e"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.prod.id
  key_name                    = "NPerez_Key"
  ebs_optimized               = false
  monitoring                  = false
  associate_public_ip_address = true
  security_groups = [
    aws_security_group.splunk-prod.id
    ]

  # root_block_device {
  #   volume_type           = "gp2"
  #   volume_size           = 10
  #   delete_on_termination = true
  # }

  tags = {
    Owner = "DSOLatam2020"
    Type = "prod"
    Name = "splunk-prod"
  }
}

resource "aws_vpc" "prod" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Owner = "DSOLatam2020"
    Type = "prod"
    Name = "vpc-prod"
  }
}

resource "aws_subnet" "prod" {
  vpc_id     = aws_vpc.prod.id
  cidr_block = "172.16.1.0/24"

  tags = {
    Owner = "DSOLatam2020"
    Type = "prod"
    Name = "subnet-prod"
  }
}

resource "aws_internet_gateway" "gw-prod" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Owner = "DSOLatam2020"
    Type = "prod"
    Name = "subnet-prod"
  }
}

resource "aws_security_group" "splunk-prod" {
  name        = "splunk"
  description = "test-splunk"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description = "Web Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Splunk group"
}

}