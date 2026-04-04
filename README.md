# 🏗️ HMS Cloud - Infrastructure as Code (IaC)

Este repositório é responsável pelo provisionamento e gerenciamento de toda a infraestrutura base na AWS para o projeto **HMS Cloud**, utilizando **Terraform**.

A filosofia central deste projeto é o **Desacoplamento Total**: a infraestrutura (redes, segurança e orquestração) possui um ciclo de vida completamente independente da aplicação (código e imagens Docker). Isso garante maior resiliência, segurança e facilidade de manutenção.


![alt text](image.png)

---

## 🎯 Objetivos e Filosofia

- **Provisionamento Automatizado:** Infraestrutura definida como código declarativo, garantindo replicabilidade em qualquer conta AWS.
- **Filosofia DRY (Don't Repeat Yourself):** Estruturação através de módulos reaproveitáveis, evitando duplicação de configurações.
- **Segurança Default (Least Privilege):** Regras de firewall estritas e IAM roles granulares, expondo apenas o estritamente necessário.
- **Orquestração de Containers:** Utilização do AWS ECS (Elastic Container Service) para garantir alta disponibilidade, auto-healing e deploys sem downtime.

---

## 🌐 Arquitetura da Infraestrutura

A topologia provisiona um ambiente robusto preparado para orquestração de containers. Para otimização de custos (aproveitando o Free Tier), o cluster ECS utiliza instâncias EC2 como *Capacity Providers* em vez do AWS Fargate.

### Camadas da Arquitetura:

1. **Camada de Rede (VPC):**
   - Criação de uma VPC isolada (`hmscloud-vpc` | `10.0.0.0/16`).
   - Internet Gateway (IGW) atachado e configurado na Route Table.
   - Subnet Pública operando na zona `us-east-1a`.

2. **Camada de Segurança (Firewall e IAM):**
   - **Security Group:** Inbound cirúrgico para as portas `80` (HTTP) e `443` (HTTPS), além de liberação de tráfego interno para o ECS Agent se comunicar com a API da AWS.
   - **IAM Roles:** Criação da `ecsTaskExecutionRole` permitindo que o cluster puxe as imagens com segurança do repositório privado no ECR.

3. **Camada de Computação (Capacity Provider):**
   - Instância `t3.micro` (Free Tier) registrada automaticamente no cluster ECS através de um script de inicialização (`user_data`) focado apenas em vincular a máquina ao cluster.

4. **Camada de Orquestração (AWS ECS):**
   - **ECS Cluster:** O painel de controle lógico (`hms-cluster`).
   - **Task Definition:** A planta arquitetônica informando ao ECS para utilizar a imagem mais recente do ECR, alocando recursos específicos de CPU e RAM.
   - **ECS Service:** O "gerente" que garante que a aplicação estará sempre rodando e reiniciará o container automaticamente em caso de falhas.

5. **Camada de Computação (Edge):**
   - Não aplicada pois gera custos, mas seria o next step da infra  

---

## 📂 Estrutura do Repositório

O projeto está organizado visando escalabilidade e modularização:

```yml
portifolio_infra/
├── .gitignore
├── README.md
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── environments/
│   ├── dev.tfvars   <-- Nossa fonte da verdade para o ambiente Dev
│   └── prod.tfvars  <-- Vazio por enquanto
├── scripts/
│   └── ecs_agent_setup.sh <-- Script enxuto apenas para atrelar a EC2 ao Cluster ECS
└── modules/
    ├── network/
    ├── security/
    ├── compute/     <-- Provisiona a EC2 (Capacity Provider)
    └── ecs/         <-- Provisiona Cluster, Task Definition e Service
```

---

## 🚀 Como Utilizar

### Pré-requisitos
* Conta na AWS ativa.
* [tfswitch](https://tfswitch.warrensbox.com/) instalado (para gerenciamento e instalação dinâmica da versão correta do Terraform).
* AWS CLI configurado com credenciais adequadas (`aws configure`).

### Passos para Provisionamento

**1. Clone o repositório:**
```bash
git clone [https://github.com/henrique-mozart-de-souza/portifolio_infra.git](https://github.com/henrique-mozart-de-souza/portifolio_infra.git)
cd portifolio_infra
```

**2. Inicialize o Terraform:**
```bash
tfswitch
terraform init
```

**2.1 Gerenciamento de Ambientes (Workspaces):**
```bash
# Para criar a primeira vez:
terraform workspace new dev

# Para selecionar em execuções futuras:
terraform workspace select dev
```

**3. Valide e Planeje:**
* Gera um plano de execução mostrando tudo que será criado na nuvem.
```bash
terraform fmt
terraform validate
terraform plan -var-file="environments/dev.tfvars"
```

**4. Aplique a Infraestrutura:**
* Provisiona os recursos reais na AWS.
```bash
terraform apply -var-file="environments/dev.tfvars"
```

**4. Aplique a Infraestrutura:**
* Provisiona os recursos reais na AWS.
```bash
terraform apply -var-file="environments/dev.tfvars"
```

**4. Aplique a Infraestrutura:**
* Provisiona os recursos reais na AWS.
```bash
terraform apply -var-file="environments/dev.tfvars"
```

**4.1 Destruindo a Infraestrutura (Rollback):**
```bash
terraform destroy -var-file="environments/dev.tfvars"
```

## No repositorio abaixo existe esse fluxo criado em Pipeline ##


https://github.com/henrique-mozart-de-souza/portifolio_CI_CD


Desenvolvido com automação extrema por Henrique Mozart de Souza.

---
