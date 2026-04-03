output "portfolio_url" {
  value       = "http://${module.compute.public_ip}"
  description = "Acesse seu portfólio neste endereço"
}