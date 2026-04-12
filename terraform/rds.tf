# ─── Subnet Group ────────────────────────────────────────────────────────────

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.project_name}-aurora-subnet-group"
  subnet_ids = aws_subnet.db_private[*].id

  tags = { Name = "${var.project_name}-aurora-subnet-group" }
}

# ─── Aurora PostgreSQL Cluster ────────────────────────────────────────────────

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.project_name}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "15.8"
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = [aws_security_group.db.id]

  backup_retention_period = 2
  preferred_backup_window = "03:00-04:00"
  deletion_protection     = false # Set to true in production
  skip_final_snapshot     = true  # Set to false in production

  tags = { Name = "${var.project_name}-aurora-cluster" }
}

# ─── Primary Instance (AZ1) ──────────────────────────────────────────────────

resource "aws_rds_cluster_instance" "primary" {
  identifier         = "${var.project_name}-aurora-primary"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version

  availability_zone    = var.availability_zones[0]
  db_subnet_group_name = aws_db_subnet_group.aurora.name

  tags = { Name = "${var.project_name}-aurora-primary" }
}

# ─── Read Replica (AZ2) ──────────────────────────────────────────────────────

resource "aws_rds_cluster_instance" "replica" {
  identifier         = "${var.project_name}-aurora-replica"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version

  availability_zone    = var.availability_zones[1]
  db_subnet_group_name = aws_db_subnet_group.aurora.name

  tags = { Name = "${var.project_name}-aurora-replica" }
}
