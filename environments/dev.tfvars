aws_region   = "us-east-1"
project_name = "hmscloud"
environment  = "dev"

vpcs = {
  "main" = { cidr_block = "10.0.0.0/16" }
}

subnets = {
  "public_1a" = {
    vpc_key           = "main"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    is_public         = true
  }
}

security_groups = {
  "web_sg" = {
    vpc_key     = "main"
    description = "SG para Web Server e SSH"
    ingress_rules = [
      { port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      { port = 22, protocol = "tcp", cidr_blocks = ["SEU_IP_AQUI/32"] } # Insira seu IP real aqui
    ]
  }
}

instances = {
  "app_server" = {
    instance_type = "t3.micro"
    subnet_key    = "public_1a"
    sg_keys       = ["web_sg"]
    volume_size   = 8
  }
}