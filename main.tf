provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name"        = "terraform-vpc-1",
    "Environment" = "dev"
  }
}

resource "aws_subnet" "terraform_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name        = "terraform-subnet-1"
    Environment = "dev"
  }
}

resource "aws_instance" "terraform_instance" {
  subnet_id     = aws_subnet.terraform_subnet.id
  ami           = "ami-0aa7d40eeae50c9a9"
  instance_type = "t2.micro"
  tags = {
    "Name"        = "terraform-instance-1",
    "Environment" = "dev"
  }
}