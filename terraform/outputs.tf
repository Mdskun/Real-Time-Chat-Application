output "web_alb_dns" {
  description = "External ALB DNS – open this in your browser"
  value       = "http://${aws_lb.web.dns_name}"
}

output "app_alb_dns" {
  description = "Internal ALB DNS (only reachable from within the VPC)"
  value       = aws_lb.app.dns_name
}

output "aurora_endpoint" {
  description = "Aurora cluster writer endpoint"
  value       = aws_rds_cluster.aurora.endpoint
}

output "aurora_reader_endpoint" {
  description = "Aurora cluster reader endpoint (routes to read replicas)"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs (Web Tier)"
  value       = aws_subnet.public[*].id
}

output "app_private_subnet_ids" {
  description = "Private subnet IDs (App Tier)"
  value       = aws_subnet.app_private[*].id
}

output "db_private_subnet_ids" {
  description = "Private subnet IDs (Database Tier)"
  value       = aws_subnet.db_private[*].id
}
