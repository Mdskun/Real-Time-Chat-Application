provider "aws" {
  region = var.region
}

# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# ---------------------------
# SUBNETS
# ---------------------------
# Public (Web Tier)
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.az1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.az2
  map_public_ip_on_launch = true
}

# Private App
resource "aws_subnet" "private_app_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = var.az1
}

resource "aws_subnet" "private_app_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = var.az2
}

# Private DB
resource "aws_subnet" "private_db_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"
  availability_zone = var.az1
}

resource "aws_subnet" "private_db_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.6.0/24"
  availability_zone = var.az2
}

# ---------------------------
# SECURITY GROUPS
# ---------------------------
resource "aws_security_group" "public_alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [aws_security_group.public_alb_sg.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal_alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    security_groups = [aws_security_group.internal_alb_sg.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
}

# ---------------------------
# PUBLIC ALB (WEB)
# ---------------------------
resource "aws_lb" "public_alb" {
  load_balancer_type = "application"
  subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups = [aws_security_group.public_alb_sg.id]
}

resource "aws_lb_target_group" "web_tg" {
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# ---------------------------
# INTERNAL ALB (APP)
# ---------------------------
resource "aws_lb" "internal_alb" {
  internal = true
  load_balancer_type = "application"
  subnets = [aws_subnet.private_app_1.id, aws_subnet.private_app_2.id]
  security_groups = [aws_security_group.internal_alb_sg.id]
}

resource "aws_lb_target_group" "app_tg" {
  port = 8000
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port = 8000
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# ---------------------------
# EC2 WEB TIER
# ---------------------------
resource "aws_launch_template" "web" {
  image_id = var.ami
  instance_type = "t3.micro"

  user_data = base64encode(file("web_user_data.sh"))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.web_sg.id]
  }
}

resource "aws_autoscaling_group" "web_asg" {
  min_size = 1
  max_size = 2
  desired_capacity = 1

  vpc_zone_identifier = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  launch_template {
    id = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]
}

# ---------------------------
# EC2 APP TIER
# ---------------------------
resource "aws_launch_template" "app" {
  image_id = var.ami
  instance_type = "t3.micro"

  user_data = base64encode(file("app_user_data.sh"))

  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
  }
}

resource "aws_autoscaling_group" "app_asg" {
  min_size = 1
  max_size = 2
  desired_capacity = 1

  vpc_zone_identifier = [aws_subnet.private_app_1.id, aws_subnet.private_app_2.id]

  launch_template {
    id = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]
}

# ---------------------------
# AURORA DB
# ---------------------------
resource "aws_db_subnet_group" "db_subnets" {
  subnet_ids = [aws_subnet.private_db_1.id, aws_subnet.private_db_2.id]
}

resource "aws_rds_cluster" "aurora" {
  engine = "aurora-postgresql"
  master_username = "admin"
  master_password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_rds_cluster_instance" "db_instances" {
  count = 2
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class = "db.t3.medium"
  engine = aws_rds_cluster.aurora.engine
}