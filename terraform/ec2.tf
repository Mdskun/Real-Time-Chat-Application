# ─── IAM Role for EC2 (SSM access – no bastion needed) ───────────────────────

resource "aws_iam_role" "ec2_ssm" {
  name = "${var.project_name}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${var.project_name}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}

# ═══════════════════════════════════════════════════════════════════════════════
#  WEB TIER  –  Nginx + React (public subnets)
# ═══════════════════════════════════════════════════════════════════════════════

resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-web-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_pair_name != "" ? var.key_pair_name : null

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_ec2.id]
  }

  # Pass the internal ALB DNS to the web tier at boot
  user_data = base64encode(templatefile("${path.module}/user_data/web.sh", {
    app_alb_dns    = aws_lb.app.dns_name
    github_repo    = var.github_repo_url
  }))

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${var.project_name}-web-instance" }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.project_name}-web-asg"
  desired_capacity    = var.web_min_size
  min_size            = var.web_min_size
  max_size            = var.web_max_size
  vpc_zone_identifier = aws_subnet.public[*].id

  target_group_arns         = [aws_lb_target_group.web.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-web-asg"
    propagate_at_launch = true
  }
}

# ─── Web Tier CPU Scaling Policy ─────────────────────────────────────────────

resource "aws_autoscaling_policy" "web_cpu" {
  name                   = "${var.project_name}-web-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

# ═══════════════════════════════════════════════════════════════════════════════
#  APP TIER  –  Django + Gunicorn (private subnets)
# ═══════════════════════════════════════════════════════════════════════════════

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_pair_name != "" ? var.key_pair_name : null

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_ec2.id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data/app.sh", {
    db_host             = aws_rds_cluster.aurora.endpoint
    db_name             = var.db_name
    db_user             = var.db_username
    db_password         = var.db_password
    django_secret_key   = var.django_secret_key
    registration_secret = var.registration_secret
    github_repo         = var.github_repo_url
    web_alb_dns         = aws_lb.web.dns_name
  }))

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${var.project_name}-app-instance" }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-app-asg"
  desired_capacity    = var.app_min_size
  min_size            = var.app_min_size
  max_size            = var.app_max_size
  vpc_zone_identifier = aws_subnet.app_private[*].id

  target_group_arns         = [aws_lb_target_group.app.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-asg"
    propagate_at_launch = true
  }
}

# ─── App Tier CPU Scaling Policy ─────────────────────────────────────────────

resource "aws_autoscaling_policy" "app_cpu" {
  name                   = "${var.project_name}-app-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
