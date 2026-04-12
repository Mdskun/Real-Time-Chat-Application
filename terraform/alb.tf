# ═══════════════════════════════════════════════════════════════════════════════
#  EXTERNAL ALB  –  Web Tier  (internet-facing)
# ═══════════════════════════════════════════════════════════════════════════════

resource "aws_lb" "web" {
  name               = "${var.project_name}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false # Set to true in production

  tags = { Name = "${var.project_name}-web-alb" }
}

# ─── Target Group: Nginx on Web EC2 (port 80) ────────────────────────────────

resource "aws_lb_target_group" "web" {
  name        = "${var.project_name}-web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = { Name = "${var.project_name}-web-tg" }
}

# ─── External ALB Listener ───────────────────────────────────────────────────

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  # NOTE: For HTTPS, add a listener on port 443 with your ACM certificate:
  # default_action { type = "forward", target_group_arn = aws_lb_target_group.web.arn }
  # certificate_arn = aws_acm_certificate.cert.arn
}


# ═══════════════════════════════════════════════════════════════════════════════
#  INTERNAL ALB  –  App Tier  (private)
# ═══════════════════════════════════════════════════════════════════════════════

resource "aws_lb" "app" {
  name               = "${var.project_name}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_alb.id]
  subnets            = aws_subnet.app_private[*].id

  enable_deletion_protection = false

  tags = { Name = "${var.project_name}-app-alb" }
}

# ─── Target Group: Gunicorn / Django on App EC2 (port 8000) ──────────────────

resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-app-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/api/health/"  # Django health-check endpoint
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = { Name = "${var.project_name}-app-tg" }
}

# ─── Internal ALB Listener ───────────────────────────────────────────────────

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 8000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
