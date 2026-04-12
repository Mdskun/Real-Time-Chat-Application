variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "chat-app"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

# ─── VPC ────────────────────────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones (must have at least 2)"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (Web Tier)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for private subnets (App Tier)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for private subnets (Database Tier)"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

# ─── EC2 ────────────────────────────────────────────────────────────────────

variable "instance_type" {
  description = "EC2 instance type for web and app tiers"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID (update per region)"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2023 ap-south-1
}

variable "key_pair_name" {
  description = "EC2 key pair name for SSH access (must already exist in AWS)"
  type        = string
  default     = ""
}

variable "web_min_size" {
  description = "Minimum number of Web Tier instances"
  type        = number
  default     = 2
}

variable "web_max_size" {
  description = "Maximum number of Web Tier instances"
  type        = number
  default     = 4
}

variable "app_min_size" {
  description = "Minimum number of App Tier instances"
  type        = number
  default     = 2
}

variable "app_max_size" {
  description = "Maximum number of App Tier instances"
  type        = number
  default     = 4
}

# ─── GitHub Repo ────────────────────────────────────────────────────────────

variable "github_repo_url" {
  description = "GitHub repository URL to clone on instances"
  type        = string
  default     = "https://github.com/your-username/your-chat-app.git"
}

# ─── Aurora Database ─────────────────────────────────────────────────────────

variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "chatapp"
}

variable "db_username" {
  description = "Master username for Aurora"
  type        = string
  default     = "chatadmin"
}

variable "db_password" {
  description = "Master password for Aurora (use AWS Secrets Manager in production)"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Aurora instance class"
  type        = string
  default     = "db.t3.medium"
}

# ─── Django ──────────────────────────────────────────────────────────────────

variable "django_secret_key" {
  description = "Django SECRET_KEY (keep this secret)"
  type        = string
  sensitive   = true
}

variable "registration_secret" {
  description = "REGISTRATION_SECRET for the chat app"
  type        = string
  sensitive   = true
}
