variable "db_identifier" {
  description = "Unique identifier for the RDS PostgreSQL instance"
  type        = string
  default     = "example-postgres"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.17"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
  default     = 100
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in GB"
  type        = number
  default     = 200
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Master username"
  type        = string
  default     = "dbadmin"
}

variable "master_password" {
  description = "Master password (do not commit real values)"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Whether the DB should be publicly accessible"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

# Networking inputs (leave empty in GitHub; required in real apply)
variable "db_subnet_group_name" {
  description = "DB subnet group name (required for VPC placement)"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for DB access control"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
