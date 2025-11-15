# Terraform AWS Free Tier Infrastructure

This Terraform configuration deploys a complete AWS Free Tier infrastructure with best practices and security improvements.

## Architecture Overview

The infrastructure consists of:
- **VPC**: Virtual Private Cloud with DNS support
- **Public Subnet**: For public-facing resources
- **Internet Gateway**: For internet connectivity
- **Route Table**: Routes internet traffic through the IGW
- **EC2 Instance**: Free tier eligible (t2.micro/t3.micro) with Ubuntu 22.04
- **Security Group**: Configured with SSH, HTTP, and HTTPS access
- **SSH Key Pair**: For secure instance access

## Security Improvements

- **IMDSv2**: Required for metadata access
- **Variable Validation**: Ensures proper input formats
- **Tagging Strategy**: Consistent tagging across all resources
- **CIDR Restrictions**: Configurable SSH access restrictions
- **Monitoring**: Detailed monitoring enabled for EC2 instances

## Directory Structure

```
src/
├── free-tier/
│   ├── main.tf          # Main configuration
│   ├── variables.tf     # Input variables with validation
│   ├── versions.tf      # Terraform and provider versions
│   └── outputs.tf       # Output values
└── modules/
    ├── vpc/            # VPC module
    ├── public-subnet/   # Public subnet module
    ├── internet-gateway/ # Internet gateway module
    ├── route-table/    # Route table module
    └── ec2/            # EC2 instance module
```

## Usage

### Prerequisites

1. Terraform >= 1.0
2. AWS CLI configured with appropriate credentials
3. SSH key pair for EC2 access

### Quick Start

1. Clone the repository and navigate to the source directory:
   ```bash
   cd src/free-tier
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review and customize variables:
   ```bash
   terraform plan -var="allowed_ssh_cidr=YOUR_IP/32"
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `profile` | AWS CLI profile | `terraform` |
| `region` | AWS region | `us-east-1` |
| `environment` | Environment name | `dev` |
| `ec2_ssh_key_name` | SSH key name | `free-tier-ec2-key` |
| `ec2_ssh_public_key_path` | Path to public key | `./provision/access/free-tier-ec2-key.pub` |
| `allowed_ssh_cidr` | SSH access CIDR | `0.0.0.0/0` |

### Outputs

After deployment, you'll get:
- VPC ID and CIDR block
- Public subnet ID
- Internet gateway ID
- EC2 instance public IP
- SSH connection command

## Best Practices Implemented

- **Provider Versioning**: Fixed provider versions for stability
- **Variable Validation**: Input validation for all configurable variables
- **Consistent Tagging**: Environment-aware resource tagging
- **Security Hardening**: IMDSv2, monitoring, restricted access
- **Modular Design**: Reusable modules for different components
- **Free Tier Compliance**: Uses only free tier eligible resources

## Cost Management

This infrastructure is designed to stay within AWS Free Tier limits:
- **EC2**: t2.micro or t3.micro (750 hours/month)
- **VPC**: No additional cost
- **Data Transfer**: 100 GB/month to internet
- **EBS**: 30 GB SSD storage

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Contributing

1. Follow the existing code style
2. Add variable validation for new inputs
3. Include proper resource tagging
4. Update documentation for changes

## License

See the main project LICENSE file.
