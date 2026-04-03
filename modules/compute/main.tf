# Busca a imagem do Ubuntu 22.04 dinamicamente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu Oficial)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # Free tier

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group]
  iam_instance_profile        = var.iam_instance_profile # Crachá do módulo security
  associate_public_ip_address = true

  # A MÁGICA ACONTECE AQUI: Injeta o nome do cluster no script bash
  user_data = templatefile("${path.root}/scripts/ecs_agent_setup.sh", {
    cluster_name = var.cluster_name
  })

  tags = {
    Name = "hms-ecs-capacity-provider-${var.environment}"
  }
}