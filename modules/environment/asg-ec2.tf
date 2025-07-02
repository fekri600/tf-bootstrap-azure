# ──────────────────────────────────────────────────────────
# modules/environment/main.tf
# ──────────────────────────────────────────────────────────

# 1) Managed Identity (replaces aws_iam_role + instance profile)
resource "azurerm_user_assigned_identity" "vm_identity" {
  name                = "${var.prefix}-${var.environment}-vm-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# 2) Role Assignment for Azure Monitor (replaces CloudWatchAgentServerPolicy)
resource "azurerm_role_assignment" "monitoring" {
  principal_id         = azurerm_user_assigned_identity.vm_identity.principal_id
  scope                = var.monitoring_resource_group_id
  role_definition_name = "Monitoring Metrics Publisher"
}

# 3) Role Assignment for DB access (replaces custom RDS connect policy)
resource "azurerm_role_assignment" "db_access" {
  principal_id         = azurerm_user_assigned_identity.vm_identity.principal_id
  scope                = azurerm_mysql_flexible_server.db.id
  role_definition_name = "Azure DB for MySQL Data Contributor"
}

# 4) Linux VM Scale Set (replaces aws_launch_template + aws_autoscaling_group)
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "${var.prefix}-${var.environment}-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location

  # Like ASG desired/min/max
  sku {
    name     = var.vm_sacale_set.instance_type    # e.g. "Standard_D2s_v3"
    tier     = "Standard"
    capacity = var.autoscaling.desired_capacity
  }
  zones               = var.network.availability_zones
  upgrade_policy_mode = "Automatic"

  # Attach our managed identity
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm_identity.id]
  }

  # Replace your SSM‐parameter AMI lookup
  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  network_profile {
    name    = "primary"
    primary = true

    ip_configuration {
      name                                         = "internal"
      subnet_id                                    = element(azurerm_subnet.private.*.id, 0)
      application_gateway_backend_address_pool_ids = [
        azurerm_application_gateway.appgw.backend_address_pool[0].id
      ]
    }
  }

  # Health probe integration with Application Gateway
  health_probe_id = azurerm_application_gateway.appgw.probe[0].id

  # Azure Monitor Agent (replaces aws_iam_role_policy_attachment.cloudwatch_agent)
  extension {
    name                       = "AzureMonitorLinuxAgent"
    publisher                  = "Microsoft.Azure.Monitor"
    type                       = "AzureMonitorLinuxAgent"
    type_handler_version       = "1.0"
    auto_upgrade_minor_version = true
  }

  tags = {
    Name = "${var.prefix}-${var.environment}-vmss"
  }
}
