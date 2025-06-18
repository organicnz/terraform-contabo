terraform {
  required_version = ">= 1.0"
  
  required_providers {
    contabo = {
      source  = "contabo/contabo"
      version = "~> 0.1.26"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

# Configure the Contabo Provider
provider "contabo" {
  oauth2_client_id     = var.contabo_client_id
  oauth2_client_secret = var.contabo_client_secret
  oauth2_user          = var.contabo_user
  oauth2_pass          = var.contabo_password
}

# Data source to get available images
data "contabo_image" "ubuntu" {
  image_id = "ubuntu-22.04"
}

# Data source to get available regions
data "contabo_data_centers" "available" {}

# Create a VPS instance
resource "contabo_instance" "main" {
  display_name = var.instance_name
  hostname     = var.hostname
  
  # Image configuration
  image_id = data.contabo_image.ubuntu.image_id
  
  # Instance specifications
  product_id = var.product_id
  region     = var.region
  
  # SSH key configuration
  ssh_keys = var.ssh_keys
  
  # User data for initial setup
  user_data = base64encode(templatefile("${path.module}/scripts/user-data.sh", {
    admin_user = var.admin_user
  }))

  # Tags for resource management
  add_ons = var.add_ons

  # Lifecycle management
  lifecycle {
    create_before_destroy = true
  }
}

# Create additional storage if needed
resource "contabo_object_storage" "backup" {
  count        = var.enable_object_storage ? 1 : 0
  display_name = "${var.instance_name}-backup"
  region       = var.region
  
  # Storage configuration
  auto_scaling {
    size_limit = var.storage_size_limit
    state      = "enabled"
  }
}

# Create a private network if needed
resource "contabo_private_network" "main" {
  count        = var.enable_private_network ? 1 : 0
  name         = "${var.instance_name}-network"
  description  = "Private network for ${var.instance_name}"
  cidr         = var.private_network_cidr
  region       = var.region
  
  # Assign instances to the network
  instance_ids = [contabo_instance.main.instance_id]
}

# Create firewall rules
resource "contabo_security_group" "main" {
  count       = var.enable_security_group ? 1 : 0
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  
  # SSH access
  rule {
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
    ip_range    = var.ssh_allowed_ips
  }
  
  # HTTP access
  rule {
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
    ip_range    = "0.0.0.0/0"
  }
  
  # HTTPS access
  rule {
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    ip_range    = "0.0.0.0/0"
  }
  
  # Custom ports
  dynamic "rule" {
    for_each = var.custom_ports
    content {
      ip_protocol = rule.value.protocol
      from_port   = rule.value.from_port
      to_port     = rule.value.to_port
      ip_range    = rule.value.ip_range
    }
  }
}

# Create snapshots for backup
resource "contabo_snapshot" "main" {
  count       = var.enable_snapshots ? 1 : 0
  instance_id = contabo_instance.main.instance_id
  name        = "${var.instance_name}-snapshot-${formatdate("YYYY-MM-DD", timestamp())}"
  description = "Automated snapshot for ${var.instance_name}"
  
  # Lifecycle to prevent recreation on every apply
  lifecycle {
    ignore_changes = [
      name,
      description
    ]
  }
} 