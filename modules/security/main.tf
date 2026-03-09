resource "aws_security_group" "this" {
  for_each    = var.security_groups
  name        = "${var.project_name}-${var.environment}-${each.key}"
  description = each.value.description
  vpc_id      = var.vpc_ids[each.value.vpc_key]

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-sg-${each.key}" }
}