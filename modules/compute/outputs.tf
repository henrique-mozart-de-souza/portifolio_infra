output "instance_ips" {
  value = { for k, v in aws_instance.this : k => v.public_ip }
}