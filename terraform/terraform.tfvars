# Copy this file to terraform.tfvars and fill in your values.
# NEVER commit terraform.tfvars to version control – add it to .gitignore

aws_region   = "ap-south-1"
project_name = "chat-app"
environment  = "prod"

# ─── Networking ───────────────────────────────────────────────────────────────
vpc_cidr            = "10.0.0.0/16"
availability_zones  = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
app_subnet_cidrs    = ["10.0.10.0/24", "10.0.11.0/24"]
db_subnet_cidrs     = ["10.0.20.0/24", "10.0.21.0/24"]

# ─── EC2 ──────────────────────────────────────────────────────────────────────
# Amazon Linux 2023 – update this for your target region:
# aws ec2 describe-images --owners amazon --filters "Name=name,Values=al2023-ami-*-x86_64" --query 'sort_by(Images,&CreationDate)[-1].ImageId'
ami_id        = "ami-0ffef61f6dc37ae89"
instance_type = "t2.micro"
key_pair_name = "k2"   # Leave "" to disable SSH

web_min_size = 2
web_max_size = 4
app_min_size = 2
app_max_size = 4

# ─── GitHub ───────────────────────────────────────────────────────────────────
github_repo_url = "https://github.com/Mdskun/chatapp.git"

# ─── Database ─────────────────────────────────────────────────────────────────
db_name           = "chatapp"
db_username       = "chatadmin"
db_password       = "123456789abc"
db_instance_class = "db.t3.medium"

# ─── Django ───────────────────────────────────────────────────────────────────
django_secret_key   = "45f56b8e8de254b28fc5443f0869d74d"
registration_secret = "00"
