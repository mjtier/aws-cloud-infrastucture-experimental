resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16" # Defines overall VPC address space
  instance_tenancy     = "default"
  enable_dns_hostnames = true # Enable DNS hostnames for this VPC
  enable_dns_support   = true # Enable DNS resolving support for this VPC
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.0.0/24"
  map_public_ip_on_launch = "true"
}

resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.main.id}"
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}