# Terraform AWS Free Tier Infrastructure

A production-ready Terraform configuration for deploying AWS Free Tier infrastructure with security best practices, multi-environment support, and comprehensive monitoring.

## 🏗️ Architecture Overview

### Core Components
- **VPC**: Virtual Private Cloud with DNS support and proper CIDR planning
- **Public Subnet**: For public-facing resources with internet access
- **Internet Gateway**: Enables internet connectivity for VPC resources
- **Route Table**: Routes internet traffic through the IGW
- **EC2 Instance**: Free tier eligible (t2.micro/t3.micro) with Ubuntu 22.04
- **Security Group**: Configured with SSH, HTTP, and HTTPS access
- **SSH Key Pair**: Secure instance access with environment-specific keys

### Security Features
- **CloudTrail**: API logging and auditing (enabled in staging/production)
- **GuardDuty**: Threat detection and monitoring (enabled in staging/production)
- **AWS Config**: Compliance monitoring and configuration tracking
- **IAM Roles**: Least-privilege access with instance profiles
- **KMS Encryption**: Encryption for sensitive data and logs
- **IMDSv2**: Required metadata access for improved security

## 📁 Project Structure

```
terraform-aws-free-tier/
├── src/                           # Source code
│   ├── free-tier/                # Main Terraform configuration
│   │   ├── main.tf               # Main orchestration
│   │   ├── variables.tf          # Variables
│   │   ├── outputs.tf            # Outputs
│   │   ├── versions.tf           # Terraform versions
│   │   ├── backend/              # Backend S3 configuration
│   │   │   └── example.config.tf
│   │   └── provision/            # Provisioning scripts
│   │       └── access/           # SSH access keys
│   ├── modules/                  # Reusable Terraform modules
│   │   ├── vpc/                 # VPC module
│   │   ├── public-subnet/       # Public subnet module
│   │   ├── internet-gateway/    # Internet gateway module
│   │   ├── route-table/         # Route table module
│   │   └── ec2/                 # EC2 instance module
│   └── README.md                 # Source documentation
├── memory-bank/                   # Project memory and context (Claude)
├── scripts/                      # Deployment and utility scripts
├── docs/                         # Documentation
├── .claude/                      # Claude Code settings (ignored)
├── .gitignore                    # Git ignore rules
├── CHANGELOG.md                  # Changelog
├── CLAUDE.md                     # Claude Code guidance
├── CONTRIBUTING.md               # Contributing guidelines
├── LEARNING-LOG.md               # Learning and development log
├── LICENSE                       # License file
└── README.md                     # This file
```

## 🚀 Quick Start

### Prerequisites

1. **Terraform >= 1.0**
2. **AWS CLI** configured with appropriate credentials
3. **Git** for version control

### Environment Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/liusc45/terraform-aws-free-tier.git
   cd terraform-aws-free-tier
   ```

2. **Generate SSH keys:**
   ```bash
   # Development
   ssh-keygen -t rsa -b 4096 -f keys/dev-ec2-key -C "dev@terraform-free-tier"
   
   # Staging
   ssh-keygen -t rsa -b 4096 -f keys/stg-ec2-key -C "stg@terraform-free-tier"
   
   # Production
   ssh-keygen -t rsa -b 4096 -f keys/prod-ec2-key -C "prod@terraform-free-tier"
   ```

3. **Initialize Terraform:**
   ```bash
   cd src/free-tier
   terraform init -backend-config="./backend/example.config.tf"
   ```

4. **Configure your variables:**
   Create a `terraform.tfvars` file:
   ```bash
   cp backend/example.config.tf backend/config.tf
   # Edit backend/config.tf with your specific configuration
   ```

### Deployment Options

#### Option 1: Using Workspaces (Recommended)

```bash
# Create and select workspace
terraform workspace new dev
terraform workspace select dev

# Plan and apply
terraform plan
terraform apply

# Switch to staging
terraform workspace select stg
terraform apply

# Switch to production
terraform workspace select prod
terraform apply
```

#### Option 2: Using Environment Directories

```bash
# Development
cd environments/dev
terraform init
terraform apply

# Staging
cd ../stg
terraform init
terraform apply

# Production
cd ../prod
terraform init
terraform apply
```

## 🔧 Configuration

### Variables

| Variable | Description | Default | Environment Override |
|----------|-------------|---------|---------------------|
| `profile` | AWS CLI profile | `terraform` | ✅ |
| `region` | AWS region | `us-east-1` | ✅ |
| `ec2_ssh_key_name` | SSH key name | `free-tier-ec2-key` | ✅ |
| `ec2_ssh_public_key_path` | Path to public key | `./keys/free-tier-ec2-key.pub` | ✅ |
| `allowed_ssh_cidr` | SSH access CIDR | `0.0.0.0/0` | ✅ |
| `vpc_cidr_block` | VPC CIDR block | `10.0.0.0/16` | ✅ |
| `subnet_cidr_block` | Subnet CIDR block | `10.0.1.0/24` | ✅ |
| `availability_zone` | Availability zone | `us-east-1a` | ✅ |

### Security Features by Environment

| Feature | Dev | Staging | Production |
|---------|-----|---------|------------|
| CloudTrail | ❌ | ✅ | ✅ |
| GuardDuty | ❌ | ✅ | ✅ |
| AWS Config | ❌ | ✅ | ✅ |
| SSH Access | Open | Corporate | Office IP |
| Monitoring | Basic | Enhanced | Full |

## 📊 Outputs

After deployment, you'll receive:

```hcl
vpc_id = "vpc-xxxxxxxxx"
vpc_cidr_block = "10.0.0.0/16"
public_subnet_id = "subnet-xxxxxxxxx"
internet_gateway_id = "igw-xxxxxxxxx"
ec2_public_ip = "x.x.x.x"
ec2_instance_id = "i-xxxxxxxxx"
ssh_connection_command = "ssh -i keys/dev-ec2-key ubuntu@x.x.x.x"
security_outputs = {
  cloudtrail_arn = "arn:aws:cloudtrail:..."
  guardduty_detector_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  config_recorder_arn = "arn:aws:config:..."
  ec2_instance_profile_arn = "arn:aws:iam::..."
}
environment = "dev"
```

## 🔒 Security Best Practices

### Implemented Controls

1. **Network Security**
   - VPC with private IP ranges
   - Security groups with least privilege
   - Configurable SSH access by CIDR

2. **Identity & Access Management**
   - IAM roles for EC2 instances
   - Instance profiles for secure API access
   - Environment-specific AWS profiles

3. **Monitoring & Logging**
   - CloudTrail for API auditing
   - GuardDuty for threat detection
   - AWS Config for compliance tracking
   - CloudWatch metrics and logs

4. **Encryption**
   - KMS keys for data encryption
   - S3 bucket encryption for logs
   - IMDSv2 for metadata protection

5. **Infrastructure as Code**
   - Version-controlled configurations
   - Environment-specific settings
   - Automated deployments
