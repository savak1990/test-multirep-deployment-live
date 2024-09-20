output "primary_address" {
  value       = module.database.address
  description = "Connect to the primary database at this endpoint"
}

output "primary_port" {
  value       = module.database.port
  description = "The port the primary database is listening on"
}

output "primary_arn" {
  value       = module.database.arn
  description = "The port the primary database is listening on"
}

output "replica_address" {
  value       = module.replica.address
  description = "Connect to the replica database at this endpoint"
}

output "replica_port" {
  value       = module.replica.port
  description = "The port the replica database is listening on"
}

output "replica_arn" {
  value       = module.replica.arn
  description = "The port the replica database is listening on"
}
