# Production Environment Configuration

# Instance Configuration
instance_name = "prod-contabo-server"
hostname      = "prod-terraform-contabo"
product_id    = "VPS-4-SSD-60"  # Larger instance for production
region        = "EU"

# SSH Configuration
admin_user      = "ubuntu"
ssh_allowed_ips = "192.168.1.0/24"  # Restrict to your office network

# Features (full features for production)
enable_object_storage   = true
enable_private_network  = true
enable_security_group   = true
enable_snapshots       = true

# Object Storage Configuration
storage_size_limit_tb = 2  # TB

# Private Network Configuration
private_network_cidr = "10.1.0.0/24"

# Custom ports for production applications
custom_ports = [
  {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    ip_range  = "0.0.0.0/0"
  }
]

# Environment and Tagging
environment = "prod"

tags = {
  Environment = "production"
  Project     = "terraform-contabo"
  ManagedBy   = "terraform"
  CostCenter  = "production"
  Backup      = "daily"
} 