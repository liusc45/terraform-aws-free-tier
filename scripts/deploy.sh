#!/bin/bash

# Terraform AWS Free Tier Deployment Script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ENVIRONMENT=""
ACTION="apply"

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_usage() {
    echo "Usage: $0 ENVIRONMENT [ACTION]"
    echo ""
    echo "ENVIRONMENTS: dev, stg, prod"
    echo "ACTIONS: plan, apply, destroy, init (default: apply)"
    echo ""
    echo "Examples:"
    echo "  $0 dev plan"
    echo "  $0 stg apply"
    echo "  $0 prod destroy"
}

if [ $# -lt 1 ]; then
    print_error "Environment is required"
    show_usage
    exit 1
fi

ENVIRONMENT=$1
ACTION=${2:-apply}

# Validate environment
case $ENVIRONMENT in
    dev|stg|prod)
        ;;
    *)
        print_error "Invalid environment: $ENVIRONMENT"
        show_usage
        exit 1
        ;;
esac

# Validate action
case $ACTION in
    plan|apply|destroy|init)
        ;;
    *)
        print_error "Invalid action: $ACTION"
        show_usage
        exit 1
        ;;
esac

print_status "Deploying to $ENVIRONMENT environment..."

# Check if environment directory exists
if [ ! -d "environments/$ENVIRONMENT" ]; then
    print_error "Environment directory not found: environments/$ENVIRONMENT"
    exit 1
fi

cd "environments/$ENVIRONMENT"

# Initialize if needed
if [ "$ACTION" = "init" ] || [ ! -d ".terraform" ]; then
    print_status "Initializing Terraform..."
    terraform init
fi

# Run specified action
case $ACTION in
    plan)
        print_status "Planning changes..."
        terraform plan -var-file="terraform.tfvars"
        ;;
    apply)
        print_status "Applying changes..."
        terraform apply -var-file="terraform.tfvars" -auto-approve
        ;;
    destroy)
        print_warning "Destroying infrastructure..."
        terraform destroy -var-file="terraform.tfvars" -auto-approve
        ;;
    init)
        print_status "Initialization completed"
        ;;
esac

print_success "Action '$ACTION' completed for $ENVIRONMENT"
