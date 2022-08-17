# Deploy taskdef to ECS
resource "aws_security_group" "lb" {
  name        = var.ecs_app_service_name
  vpc_id      = aws_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb" "app" {
  name            = var.ecs_app_service_name
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "app" {
  name        = var.ecs_app_service_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app.id
    type             = "forward"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.ecs_app_service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = <<DEFINITION
[
  {
    "image": "nginx",
    "cpu": 256,
    "memory": 256,
    "name": "${var.ecs_app_service_name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

output "load_balancer_ip" {
  value = aws_lb.app.dns_name
}