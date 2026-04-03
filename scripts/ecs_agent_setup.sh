#!/bin/bash
# Atualiza o sistema
apt-get update -y

# Instala o agente do ECS (caso não use a AMI otimizada da Amazon)
# Mas a forma mais simples em Ubuntu é via Docker:
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config

# Instalação simplificada do Docker (Docker-in-Docker não necessário aqui)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Roda o agente do ECS como um container privilegiado
docker run --name ecs-agent \
    --detach=true \
    --restart=on-failure:10 \
    --volume=/var/run:/var/run \
    --volume=/var/log/ecs/:/var/log/ecs/ \
    --volume=/var/lib/ecs/data:/var/lib/ecs/data \
    --volume=/etc/ecs:/etc/ecs \
    --net=host \
    --env-file=/etc/ecs/ecs.config \
    amazon/amazon-ecs-agent:latest