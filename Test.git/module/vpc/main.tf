#VPC
resource "aws_vpc" "vpc" {
  cidr_block             = var.vpc_cidr
    enable_dns_hostnames = true
  enable_dns_support     = true
      tags = {
        Name = "Snapwork-Demo-VPC"
      }
    }

#Internet Gateway 
resource "aws_internet_gateway" "IGW" {    
    vpc_id      =  aws_vpc.vpc.id   
      tags  = {
          Name = "My-IGW"
          }
    }   

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidr,count.index)
  availability_zone       = element(var.public_azs,count.index)
  map_public_ip_on_launch = true
        tags = {
          Name = "Public_Subnet-${count.index+1}"
        }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count                    = length(var.private_subnet_cidr)
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = element(var.private_subnet_cidr,count.index)
  availability_zone        = element(var.private_azs,count.index)
  map_public_ip_on_launch  = false
  tags = {
    Name = "Private_Subnet-${count.index+1}"
  }
}
 
# Creating RT for Public Subnet and attach internet gateway
resource "aws_route_table" "PublicRT" {    
    vpc_id             =  aws_vpc.vpc.id
          route {
            cidr_block = "0.0.0.0/0"                
            gateway_id = aws_internet_gateway.IGW.id
        }
 }

# Route table association with public subnets
resource "aws_route_table_association" "pub-sub-asso" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id,count.index)
  route_table_id = aws_route_table.PublicRT.id
}

# Creating RT for Private Subnet and attach NAT gateway
resource "aws_route_table" "PrivateRT1" {    
    vpc_id             =  aws_vpc.vpc.id
          route {
            cidr_block = "0.0.0.0/0"                
            nat_gateway_id = aws_nat_gateway.Nat-GW1.id
        }
 }

 resource "aws_route_table" "PrivateRT2" {    
    vpc_id             =  aws_vpc.vpc.id
          route {
            cidr_block = "0.0.0.0/0"                
            nat_gateway_id = aws_nat_gateway.Nat-GW2.id
        }
 }

# Allocate Elastic IP
 resource "aws_eip" "eip1" {
vpc      = true
 }
 
 resource "aws_eip" "eip2" {
  vpc      = true
}

# Creating a NAT Gateway
resource "aws_nat_gateway" "Nat-GW1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_nat_gateway" "Nat-GW2" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet[1].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.IGW]
}

