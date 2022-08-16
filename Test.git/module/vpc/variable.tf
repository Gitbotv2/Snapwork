
variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}


variable "public_subnet_cidr" {
	type = list
}

variable "public_azs" {
	type = list
}

variable "private_subnet_cidr" {
	type = list
}

variable "private_azs" {
	type = list
}

