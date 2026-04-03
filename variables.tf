variable "aws_region" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }

variable "vpcs" {
  type = map(object({ cidr_block = string }))
}

variable "subnets" {
  type = map(object({
    vpc_key           = string
    cidr_block        = string
    availability_zone = string
    is_public         = bool
  }))
}

variable "security_groups" {
  type = map(object({
    vpc_key       = string
    description   = string
    ingress_rules = list(object({
      port        = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "instances" {
  type = map(object({
    instance_type = string
    subnet_key    = string
    sg_keys       = list(string)
    volume_size   = number
  }))
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_account_id" {
  default = "365916940374"
}

variable "project_name" {
  default = "hms-cloud"
}

variable "ecr_repo_name" {
  default = "meu-portfolio"
}