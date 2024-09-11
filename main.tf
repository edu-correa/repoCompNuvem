terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.16"
   }
 }

 required_version = ">= 1.2.0"
 
} 

provider "aws" {
 region = "us-east-1"
}

resource "aws_vpc" "ec2-priv-rede-sptech" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ec2-pub-rede-sptech"
  }
}

resource "aws_vpc" "ec2-pub-rede-sptech" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ec2-priv-rede-sptech"
  }
}

# Criação da Subnet privada
resource "aws_subnet" "sub-az1-pub-lab01-sptech" {
  vpc_id     = aws_vpc.ec2-pub-rede-sptech.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sub-az1-pub-lab01-sptech"
  }
}
# Criação da Subnet Pública
resource "aws_subnet" "sub-az1-priv-lab01-sptech" {
  vpc_id     = aws_vpc.ec2-priv-rede-sptech.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sub-az1-priv-lab01-sptech"
  }
}

# Criação do Internet Gateway
resource "aws_internet_gateway" "igw_lab02-sptech" {
  vpc_id = aws_vpc.ec2-pub-rede-sptech.id

  tags = {
    Name = "igw_lab02-sptech"
  }
}

# Criação da Tabela de Roteamento
resource "aws_route_table" "rtb-lab02-sptech" {
  vpc_id = aws_vpc.ec2-pub-rede-sptech.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_lab02-sptech.id
  }

  tags = {
    Name = "rtb-lab02-sptech"
  }
}

# Criação da Rota Default para Acesso à Internet
resource "aws_route" "tcb_blog_routetointernet" {
  route_table_id            = aws_route_table.rtb-lab02-sptech.id
  destination_cidr_block    = "10.0.0.0/24"
  gateway_id                = aws_internet_gateway.igw_lab02-sptech.id
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "tcb_blog_pub_association" {
  subnet_id      = aws_subnet.sub-az1-pub-lab01-sptech.id
  route_table_id = aws_route_table.rtb-lab02-sptech.id
  
}