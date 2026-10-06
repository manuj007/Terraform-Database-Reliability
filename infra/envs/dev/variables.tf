variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devops-assignment-dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "local-review-password"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "backup_retention_period" {
  description = "RDS backup retention period"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "RDS deletion protection"
  type        = bool
  default     = false
}
