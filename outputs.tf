output "instance_ips" {
  description = "IPs Públicos das instâncias criadas"
  value       = module.compute.instance_ips
}