output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.public_subnet.public_subnet_id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = module.internet_gateway.internet_gateway_id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2.ec2_public_ip
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.ec2_instance_id
}

output "ssh_connection_command" {
  description = "Command to connect to the EC2 instance via SSH"
  value       = "ssh -i ${var.ec2_ssh_public_key_path}.pem ubuntu@${module.ec2.ec2_public_ip}"
  sensitive   = false
}
