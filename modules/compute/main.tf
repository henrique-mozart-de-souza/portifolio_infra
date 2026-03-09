data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "this" {
  for_each               = var.instances
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = each.value.instance_type
  subnet_id              = var.subnet_ids[each.value.subnet_key]
  
  vpc_security_group_ids = [for sg_key in each.value.sg_keys : var.sg_ids[sg_key]]
  
  user_data              = file("${path.root}/scripts/setup_ec2.sh")

  root_block_device {
    volume_size = each.value.volume_size
    volume_type = "gp3"
  }

  tags = { Name = "${var.project_name}-${var.environment}-ec2-${each.key}" }
}