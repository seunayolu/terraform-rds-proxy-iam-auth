variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "default_route" {
  description = "default"
  type        = string
}

variable "publicip-01" {
  description = "Public IP from STRLNK"
  type        = string
}

variable "publicip-02" {
  description = "Public IP from ARTL"
  type        = string
}