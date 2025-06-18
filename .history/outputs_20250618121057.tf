# Instance Outputs
output "instance_id" {
  description = "ID of the created Contabo instance"
  value       = contabo_instance.main.instance_id
}

output "instance_name" {
  description = "Display name of the created instance"
  value       = contabo_instance.main.display_name
}

output "instance_hostname" {
  description = "Hostname of the created instance"
  value       = contabo_instance.main.hostname
}

output "instance_status" {
  description = "Current status of the instance"
  value       = contabo_instance.main.status
}

output "instance_ip_config" {
  description = "IP configuration of the instance"
  value       = contabo_instance.main.ip_config
  sensitive   = false
}

output "instance_public_ips" {
  description = "Public IP addresses of the instance"
  value = [
    for ip in contabo_instance.main.ip_config : ip.v4.ip
    if ip.v4 != null
  ]
}

output "instance_ipv6_addresses" {
  description = "IPv6 addresses of the instance"
  value = [
    for ip in contabo_instance.main.ip_config : ip.v6.ip
    if ip.v6 != null
  ]
}

# Network Outputs
output "private_network_id" {
  description = "ID of the private network (if created)"
  value       = var.enable_private_network ? contabo_private_network.main[0].network_id : null
}

output "private_network_cidr" {
  description = "CIDR block of the private network (if created)"
  value       = var.enable_private_network ? contabo_private_network.main[0].cidr : null
}

# Note: Security groups are not supported by the Contabo provider
# Firewall rules are managed at the OS level through UFW

# Storage Outputs
output "object_storage_id" {
  description = "ID of the object storage (if created)"
  value       = var.enable_object_storage ? contabo_object_storage.backup[0].object_storage_id : null
}

output "object_storage_s3_url" {
  description = "S3 URL of the object storage (if created)"
  value       = var.enable_object_storage ? contabo_object_storage.backup[0].s3_url : null
  sensitive   = true
}

# Snapshot Outputs
output "snapshot_id" {
  description = "ID of the created snapshot (if enabled)"
  value       = var.enable_snapshots ? contabo_snapshot.main[0].snapshot_id : null
}

output "snapshot_name" {
  description = "Name of the created snapshot (if enabled)"
  value       = var.enable_snapshots ? contabo_snapshot.main[0].name : null
}

# Data Source Outputs
output "available_data_centers" {
  description = "List of available Contabo data centers"
  value       = data.contabo_data_centers.available.data_centers
}

output "ubuntu_image_info" {
  description = "Information about the Ubuntu image being used"
  value = {
    image_id    = data.contabo_image.ubuntu.image_id
    name        = data.contabo_image.ubuntu.name
    description = data.contabo_image.ubuntu.description
  }
}

# Resource Summary
output "resource_summary" {
  description = "Summary of all created resources"
  value = {
    instance = {
      id         = contabo_instance.main.instance_id
      name       = contabo_instance.main.display_name
      hostname   = contabo_instance.main.hostname
      product_id = contabo_instance.main.product_id
      region     = contabo_instance.main.region
      status     = contabo_instance.main.status
    }
    private_network = var.enable_private_network ? {
      id   = contabo_private_network.main[0].network_id
      cidr = contabo_private_network.main[0].cidr
    } : null
    security_group = var.enable_security_group ? {
      id = contabo_security_group.main[0].security_group_id
    } : null
    object_storage = var.enable_object_storage ? {
      id = contabo_object_storage.backup[0].object_storage_id
    } : null
    snapshot = var.enable_snapshots ? {
      id   = contabo_snapshot.main[0].snapshot_id
      name = contabo_snapshot.main[0].name
    } : null
  }
}

# Connection Information
output "ssh_connection_commands" {
  description = "SSH connection commands for the instance"
  value = [
    for ip in contabo_instance.main.ip_config : "ssh ${var.admin_user}@${ip.v4.ip}"
    if ip.v4 != null
  ]
} 