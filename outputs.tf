output "portfolio_url" {
  description = "Acesse seu portfólio neste endereço"
  value       = "http://${module.compute.public_ip}"
}