# ==============================================================================
# 1. IAM ROLE (O Crachá de Acesso)
# O ECS precisa de permissão para "conversar" com o seu ECR e puxar a imagem.
# ==============================================================================

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "hms-ecs-task-execution-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Anexando a política padrão da AWS que permite puxar imagens do ECR e gerar logs

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ==============================================================================
# 2. ECS CLUSTER (O Condomínio)
# O painel de controle lógico que vai gerenciar a sua instância EC2.
# ==============================================================================

resource "aws_ecs_cluster" "main" {
  name = "hms-cluster-${var.environment}"

  tags = {
    Name        = "hms-cluster-${var.environment}"
    Environment = var.environment
  }
}

# ==============================================================================
# 3. TASK DEFINITION (A Planta Baixa do Container)
# Diz ao ECS qual imagem usar, quanta memória alocar e qual porta abrir.
# ==============================================================================

resource "aws_ecs_task_definition" "app" {
  family                   = "hms-portfolio-task-${var.environment}"
  network_mode             = "bridge" # Ideal para instâncias EC2 simples
  requires_compatibilities = ["EC2"]  # Força o uso do modelo EC2 (Free Tier) em vez do Fargate
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  # O JSON que define o container em si
  container_definitions = jsonencode([
    {
      name      = "hms-portfolio-container"
      image     = var.ecr_image_url # Variável que receberá o link da sua imagem no ECR
      cpu       = 256               # 0.25 vCPU
      memory    = 512               # 512 MB de RAM (metade da sua t3.micro)
      essential = true

      portMappings = [
        {
          containerPort = 5000 # A porta que o Flask expõe internamente
          hostPort      = 80   # A porta que a EC2 vai expor para a internet
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ==============================================================================
# 4. ECS SERVICE (O Gerente)
# Mantém o container vivo e garante que tenhamos 1 cópia rodando.
# ==============================================================================

resource "aws_ecs_service" "app_service" {
  name            = "hms-portfolio-service-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1 # Queremos apenas 1 container rodando para o Free Tier
  launch_type     = "EC2"

  # Só inicia o serviço depois que a Role do IAM estiver totalmente criada
  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}