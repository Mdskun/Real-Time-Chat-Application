# ─── External ALB Security Group ─────────────────────────────────────────────
# Accepts HTTP/HTTPS from the internet

resource "aws_security_group" "web_alb" {
  name        = "${var.project_name}-web-alb-sg"
  description = "External ALB: allow HTTP/HTTPS from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-web-alb-sg" }
}

# ─── Web Tier (EC2) Security Group ───────────────────────────────────────────
# Accepts traffic only from the external ALB

resource "aws_security_group" "web_ec2" {
  name        = "${var.project_name}-web-ec2-sg"
  description = "Web EC2: allow traffic from external ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from external ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb.id]
  }

  ingress {
    description     = "HTTPS from external ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb.id]
  }

  # Allow SSH from within VPC (via bastion or Systems Manager)
  ingress {
    description = "SSH within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-web-ec2-sg" }
}

# ─── Internal ALB Security Group ─────────────────────────────────────────────
# Accepts traffic only from Web Tier EC2 instances

resource "aws_security_group" "app_alb" {
  name        = "${var.project_name}-app-alb-sg"
  description = "Internal ALB: allow traffic from Web EC2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Django API from Web EC2"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.web_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-app-alb-sg" }
}

# ─── App Tier (EC2) Security Group ───────────────────────────────────────────
# Accepts traffic only from the internal ALB

resource "aws_security_group" "app_ec2" {
  name        = "${var.project_name}-app-ec2-sg"
  description = "App EC2: allow traffic from internal ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Django from internal ALB"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.app_alb.id]
  }

  ingress {
    description = "SSH within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-app-ec2-sg" }
}

# ─── Database Security Group ──────────────────────────────────────────────────
# Accepts PostgreSQL only from App Tier EC2

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Aurora: allow PostgreSQL from App EC2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from App EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-db-sg" }
}
