# Create VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Subnets
resource "aws_subnet" "mysub1" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "mysub2" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.16.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "mysub3" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "mysub4" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.24.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = false
}

# Create Internet Gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
}

# Attach Internet Gateway
resource "aws_internet_gateway_attachment" "myigw_attachment" {
  vpc_id             = aws_vpc.myvpc.id
  internet_gateway_id = aws_internet_gateway.myigw.id
}

# Create public route
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
}

# Create private route
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.myvpc.id
}

# Route table subnet association
resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.mysub1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.mysub2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.mysub3.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.mysub4.id
  route_table_id = aws_route_table.private_route.id
}
# Create Network ACLs
resource "aws_network_acl" "public_acls" {
  vpc_id = aws_vpc.myvpc.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65525
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65525

  }

}

resource "aws_network_acl" "private_acls" {
  vpc_id = aws_vpc.myvpc.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/24"
    from_port  = 0
    to_port    = 22
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 22
  }

}

# Create Security Groups
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create instance
resource "aws_instance" "webserver" {
  ami                    = "ami-007020fd9c84e18c7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = aws_subnet.mysub1.id
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "mynat" {
  instance = aws_instance.webserver.id
  domain   = "vpc"
}

# Create NAT Gateway
resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.mynat.id
  subnet_id     = aws_subnet.mysub1.id
  depends_on    = [aws_internet_gateway.myigw]
}


