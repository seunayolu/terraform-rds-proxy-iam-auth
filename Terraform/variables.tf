variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_iam_auth_user" {
  description = "DB IAM Auth User"
  type        = string
}

variable "db_engine" {
  description = "Database Engine Type"
  type        = string
}

variable "db_storage_type" {
  description = "Database Storage Type"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_storage_size" {
  description = "RDS storage size in GB"
  type        = number
}

variable "db_engine_version" {
  description = "RDS MySQL engine version"
  type        = string
}

variable "app_port" {
  description = "NodeJs Port"
  type        = string
}

variable "https_port" {
  description = "HTTPS Port"
  type        = string
}

variable "http_port" {
  description = "HTTPS Port"
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

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
}

variable "volume_type" {
  description = "Type of the EBS volume (e.g., gp2, gp3)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "ssl_policy" {
  description = "ALB SSL Policy"
  type        = string
}

variable "loadbalancer_type" {
  description = "ELB Type"
  type        = string
}

variable "target_type" {
  description = "Target Type for EC2 Target Group"
  type        = string
}

variable "domain_name" {
  description = "value"
  type        = string
}
