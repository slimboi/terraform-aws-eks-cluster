variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "private_subnets_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnets_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}