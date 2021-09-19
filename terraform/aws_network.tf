#Creating VPC (Virtual Private Cloud in AWS US-WEST-1 Region)

resource "aws_vpc" "main_vpc" {
    cidr_block = "20.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "main-vpc"
    }
}

#Creating IGW (Internet Gateway)
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main_vpc.id
}

#Fetch all available AZ's in VPC for us-west-1 region

data "aws_availability_zones" "azs" {
    state = "available"
}

# Creating Subnet #1 in us-west-1 region

resource "aws_subnet" "subnet_1" {
    availability_zone = element(data.aws_availability_zones.azs.names, 0)
    vpc_id = aws_vpc.main_vpc.id
    map_public_ip_on_launch = true
    cidr_block = "20.0.1.0/24"
}

# Creating Subnet #2 in us-west-1 region

resource "aws_subnet" "subnet_2" {
    availability_zone = element(data.aws_availability_zones.azs.names, 1)
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "20.0.2.0/24"
}

# Creation Route_tables

resource "aws_route_table" "internet_route" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    lifecycle{
        ignore_changes = all
    }
    tags = {
        Name = "my_route_table"
    }
}

# Creating Route table association with VPC

resource "aws_main_route_table_association" "my-rt-association" {
    vpc_id = aws_vpc.main_vpc.id
    route_table_id = aws_route_table.internet_route.id
}

# Creating Security Groups LB, only TCP/80,TCP/443 and outbound access
resource "aws_security_group" "my_sg" {
    name = "my_sg"
    description = "Allow traffic to SG"
    vpc_id = aws_vpc.main_vpc.id
    ingress {
        description = "Allow Port 22 for SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow 443 from anywhere"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow 80 from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

