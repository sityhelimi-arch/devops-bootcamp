output "rackula_url" {
  description = "URL to access Rackula"
  value       = "http://${module.my_server.public_ip}:8080"
}

output "ssm_command" {
  description = "SSM Session Manager command to connect to the instance"
  value       = "aws ssm start-session --target ${module.my_server.id}"
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.my_server.id
}
