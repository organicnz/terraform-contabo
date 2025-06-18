# Terraform Contabo Infrastructure Stack

This repository contains Terraform configuration files for managing Contabo VPS infrastructure. It provides a complete, production-ready setup for deploying and managing Contabo virtual private servers with additional services like object storage, private networking, and security groups.

## 🚀 Features

- **Complete VPS Management**: Deploy and manage Contabo VPS instances
- **Security Groups**: Configurable firewall rules for network security
- **Private Networking**: Optional private network setup for secure communication
- **Object Storage**: Integrated backup storage solution
- **Automated Snapshots**: Scheduled backups for disaster recovery
- **User Data Scripts**: Automated server initialization and software installation
- **Multi-Environment Support**: Separate configurations for dev, staging, and production
- **Comprehensive Outputs**: All important resource information exposed

## 📋 Prerequisites

1. **Contabo Account**: Active Contabo account with API access
2. **API Credentials**: OAuth2 credentials from Contabo Customer Control Panel
3. **Terraform**: Version 1.0 or higher
4. **SSH Keys**: SSH keys uploaded to your Contabo account (optional but recommended)

## 🛠️ Setup Instructions

### 1. Clone and Configure

```bash
git clone <your-repo-url>
cd terraform-contabo
```

### 2. Get Contabo API Credentials

1. Log into your [Contabo Customer Control Panel](https://my.contabo.com/)
2. Navigate to API settings
3. Create new OAuth2 credentials
4. Note down: Client ID, Client Secret, Username, and Password

### 3. Configure Variables

Copy the example configuration and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your actual values:

```hcl
# Required: Contabo API Credentials
contabo_client_id     = "your-actual-client-id"
contabo_client_secret = "your-actual-client-secret"
contabo_user          = "your-api-username"
contabo_password      = "your-api-password"

# Instance Configuration
instance_name = "my-server"
hostname      = "my-hostname"
product_id    = "VPS-2-SSD-20"
region        = "EU"
```

### 4. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

## 🏗️ Architecture

### Core Components

- **VPS Instance**: Primary compute resource with Ubuntu 24.04
- **Security Group**: Firewall rules for SSH, HTTP, HTTPS, and custom ports
- **Object Storage**: S3-compatible storage for backups (optional)
- **Private Network**: Isolated network for secure communication (optional)
- **Snapshots**: Automated backup system (optional)

### Network Configuration

- **Public IP**: Automatically assigned IPv4 and IPv6 addresses
- **Private Network**: Optional 10.0.0.0/24 network for internal communication
- **Firewall**: UFW configured with fail2ban for SSH protection

## 📁 Project Structure

```
terraform-contabo/
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output values
├── terraform.tfvars.example   # Example configuration
├── terraform.tfvars          # Your actual configuration (not in git)
├── scripts/
│   └── user-data.sh          # Server initialization script
├── environments/
│   ├── dev/
│   │   └── terraform.tfvars  # Development environment config
│   └── prod/
│       └── terraform.tfvars  # Production environment config
└── README.md                 # This file
```

## 🔧 Configuration Options

### Instance Types (Product IDs)

| Product ID | vCPUs | RAM | Storage | Price Range |
|------------|-------|-----|---------|-------------|
| VPS-1-SSD-10 | 1 | 4GB | 50GB SSD | €4.99/month |
| VPS-2-SSD-20 | 2 | 8GB | 100GB SSD | €8.99/month |
| VPS-3-SSD-40 | 4 | 12GB | 200GB SSD | €14.99/month |
| VPS-4-SSD-60 | 6 | 16GB | 400GB SSD | €21.99/month |
| VPS-5-SSD-100 | 8 | 30GB | 800GB SSD | €38.99/month |
| VPS-6-SSD-200 | 10 | 60GB | 1.6TB SSD | €68.99/month |

### Available Regions

- `EU`: European data centers
- `US-central`: Central US
- `US-east`: East Coast US
- `US-west`: West Coast US
- `SIN`: Singapore

### Optional Features

```hcl
# Enable/disable optional features
enable_object_storage   = true   # S3-compatible backup storage
enable_private_network  = true   # Isolated network
enable_security_group   = true   # Firewall rules
enable_snapshots       = true   # Automated backups
```

## 🌍 Multi-Environment Usage

Deploy to different environments using environment-specific configurations:

```bash
# Development environment
terraform apply -var-file="environments/dev/terraform.tfvars"

# Production environment
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## 🔒 Security Best Practices

1. **Restrict SSH Access**: Limit `ssh_allowed_ips` to your network
2. **Use SSH Keys**: Configure SSH key authentication
3. **Regular Updates**: The user-data script enables automatic security updates
4. **Firewall Configuration**: UFW and fail2ban are automatically configured
5. **Strong Passwords**: Use complex passwords for API credentials

## 📊 Monitoring and Maintenance

### View Outputs

```bash
# Show all outputs
terraform output

# Show specific output
terraform output instance_public_ips
terraform output ssh_connection_commands
```

### Connect to Instance

```bash
# SSH connection (replace with actual IP)
ssh ubuntu@<instance-ip>

# Check initialization status
ssh ubuntu@<instance-ip> "cat /var/log/terraform-init-status"
```

### Backup and Snapshots

If snapshots are enabled, automatic backups are created. You can also create manual snapshots:

```bash
# Create manual snapshot
terraform apply -var="create_manual_snapshot=true"
```

## 🛠️ Troubleshooting

### Common Issues

1. **API Authentication Failed**
   - Verify API credentials in terraform.tfvars
   - Check if API access is enabled in Contabo panel

2. **Instance Creation Failed**
   - Verify product_id is valid for your region
   - Check if you have sufficient credit/limits

3. **SSH Connection Issues**
   - Verify security group allows SSH (port 22)
   - Check if SSH keys are properly configured

### Debug Commands

```bash
# Enable detailed logging
export TF_LOG=DEBUG
terraform apply

# Validate configuration
terraform validate

# Format code
terraform fmt

# Show current state
terraform show
```

## 🔄 Updates and Cleanup

### Update Infrastructure

```bash
# Check for changes
terraform plan

# Apply updates
terraform apply
```

### Cleanup Resources

```bash
# Destroy all resources
terraform destroy

# Destroy specific resource
terraform destroy -target="contabo_instance.main"
```

## 📝 Customization

### Adding Custom Software

Edit `scripts/user-data.sh` to install additional software during initialization:

```bash
# Add your custom installation commands
echo "Installing custom software..."
apt-get install -y your-package
```

### Custom Firewall Rules

Add custom ports in your terraform.tfvars:

```hcl
custom_ports = [
  {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    ip_range  = "0.0.0.0/0"
  }
]
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes
4. Submit a pull request

## 📞 Support

- **Terraform Documentation**: [terraform.io/docs](https://terraform.io/docs)
- **Contabo API Documentation**: [contabo.com/api](https://contabo.com/api)
- **Contabo Support**: [contabo.com/support](https://contabo.com/support)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: Always review the execution plan before applying changes to production environments. Keep your API credentials secure and never commit them to version control. 