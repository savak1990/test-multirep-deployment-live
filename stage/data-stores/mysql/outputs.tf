output "db_address" {
  value       = module.database.address
  description = "Connect to the primary database at this endpoint"
}

output "db_port" {
  value       = module.database.port
  description = "The port the primary database is listening on"
}

output "db_arn" {
  value       = module.database.arn
  description = "The port the primary database is listening on"
}
