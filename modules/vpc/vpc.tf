
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags                 = var.tags
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.vpc_cidr
  availability_zone       = join("", [var.availability_zone, var.az_number])
  map_public_ip_on_launch = true
  tags = {
    Name        = var.name
    Description = var.description
  }

  depends_on = [
    aws_vpc.this
  ]
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}