variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "terraform"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.profile))
    error_message = "The profile name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.region))
    error_message = "The region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "ec2_ssh_key_name" {
  description = "The SSH Key Name"
  type        = string
  default     = "free-tier-ec2-key"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.ec2_ssh_key_name))
    error_message = "SSH key name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ec2_ssh_public_key_path" {
  description = "The local path to the SSH Public Key"
  type        = string
  default     = "./provision/access/free-tier-ec2-key.pub"
  
  validation {
    condition     = fileexists(var.ec2_ssh_public_key_path)
    error_message = "SSH public key file must exist at the specified path."
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into EC2 instances"
  type        = string
  default     = "0.0.0.0/0"
  
  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}
