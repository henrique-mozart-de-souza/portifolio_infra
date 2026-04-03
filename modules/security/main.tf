# 1. O Firewall (Security Group)
resource "aws_security_group" "web_sg" {
  name        = "hms-web-sg-${var.environment}"
  description = "Permite HTTP, HTTPS e SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Em um cenário real, restrinja para o seu IP!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. O Crachá da EC2 (IAM Role para ECS Capacity Provider)
resource "aws_iam_role" "ecs_instance_role" {
  name = "hms-ecs-instance-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Dá poder para a EC2 falar com o ECS
resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# O Perfil que será anexado na máquina
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "hms-ecs-instance-profile-${var.environment}"
  role = aws_iam_role.ecs_instance_role.name
}