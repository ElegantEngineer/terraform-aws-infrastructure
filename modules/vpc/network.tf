resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = {
    Name = "NAT Internet Gateway"
  }
  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-crt"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table_association" "crta-public-subnet"{
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.public-crt.id}"
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = "${aws_vpc.this.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    // This means, all ip address are allowed to ssh
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-allowed"
  }
}

resource "aws_security_group" "web-allowed" {
  vpc_id = "${aws_vpc.this.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name = "web-allowed"
  }
}

resource "aws_security_group" "local-allowed" {
  vpc_id = "${aws_vpc.this.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  tags = {
    Name = "local-allowed"
  }
}

output "aws_ssh_security_group_id" {
  value = aws_security_group.ssh-allowed.id
}

output "aws_web_security_group_id" {
  value = aws_security_group.web-allowed.id
}

output "aws_local_security_group_id" {
  value = aws_security_group.local-allowed.id
}