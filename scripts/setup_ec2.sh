#!/bin/bash

# Log de execução do User Data para facilitar debug futuro
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Iniciando processo de Bootstrapping HMS Cloud..."

# 1. Atualização do sistema
apt-get update -y
apt-get upgrade -y

# 2. Instalação de dependências essenciais
apt-get install -y docker.io docker-compose nginx certbot python3-certbot-nginx git curl

# 3. Habilitar e iniciar serviços
systemctl enable docker
systemctl start docker
systemctl enable nginx
systemctl start nginx

# 4. Ajuste de permissões do Docker para o usuário ubuntu
usermod -aG docker ubuntu

# 5. Criando a configuração inicial do Nginx como Proxy Reverso (Porta 80 -> 5000)
# (O Certbot será rodado posteriormente quando o domínio apontar para o IP)
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Reinicia o Nginx para aplicar a regra
systemctl restart nginx

echo "Bootstrapping concluído com sucesso! Máquina pronta para o container."