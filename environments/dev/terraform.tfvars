# Development Environment Configuration

# Instance Configuration
instance_name = "dev-contabo-server"
hostname      = "dev-terraform-contabo"
product_id    = "VPS-1-SSD-10"  # Smaller instance for dev
region        = "EU"

# SSH Configuration
admin_user      = "ubuntu"
ssh_allowed_ips = "0.0.0.0/0"  # Consider restricting this in production

# Features (minimal for dev environment)
enable_object_storage   = false
enable_private_network  = false
enable_security_group   = true
enable_snapshots       = false

# Environment and Tagging
environment = "dev"

tags = {
  Environment = "development"
  Project     = "terraform-contabo"
  ManagedBy   = "terraform"
  CostCenter  = "development"
} 