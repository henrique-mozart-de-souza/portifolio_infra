# Busca a imagem oficial da AWS otimizada para o ECS
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ecs_ami.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group]
  iam_instance_profile   = var.iam_instance_profile

  # Esse script roda quando a máquina liga e registra ela no Cluster correto
  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
              EOF

  tags = {
    Name = "hms-ecs-instance-${var.environment}"
  }
}