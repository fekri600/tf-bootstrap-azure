#################################
# Public IP for the App Gateway
#################################
resource "azurerm_public_ip" "appgw" {
  name                = "${var.prefix}-${var.environment}-appgw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = {
    Name = "${var.prefix}-${var.environment}-appgw-pip"
  }
}

#################################
# Application Gateway (v2)
#################################
resource "azurerm_application_gateway" "appgw" {
  name                = "${var.prefix}-${var.environment}-appgw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = var.load_balancer.alb_settings.capacity
  }

  gateway_ip_configuration {
    name      = "appgw-ipcfg"
    subnet_id = azurerm_subnet.public[0].id
  }

  frontend_port {
    name = "httpPort"
    port = var.load_balancer.listener.port.http
  }

  frontend_ip_configuration {
    name                 = "appgw-frontendip"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  #################################
  # Backend Pool (Target Group)
  #################################
  backend_address_pool {
    name = "appgw-backendpool"
    # Attach your VMs/VMSS NIC IPs here if static, or leave empty for dynamic
    # ip_addresses = [azurerm_linux_virtual_machine.vm.*.private_ip_address]
  }

  #################################
  # HTTP Settings (port/protocol)
  #################################
  backend_http_settings {
    name                  = "appgw-httpsettings"
    cookie_based_affinity = "Disabled"
    port                  = var.load_balancer.lb_target_group.port
    protocol              = var.load_balancer.lb_target_group.protocol
    request_timeout       = var.load_balancer.lb_health_check.timeout
  }

  #################################
  # Health Probe (Health Check)
  #################################
  probe {
    name                = "appgw-healthprobe"
    protocol            = var.load_balancer.lb_target_group.protocol
    path                = var.load_balancer.lb_health_check.path
    interval            = var.load_balancer.lb_health_check.interval
    timeout             = var.load_balancer.lb_health_check.timeout
    unhealthy_threshold = var.load_balancer.lb_health_check.unhealthy_threshold

    match {
      status_codes = [for code in split(",", var.load_balancer.lb_health_check.matcher) : trim(code)]
    }
  }

  #################################
  # Listener & Routing Rule
  #################################
  http_listener {
    name                           = "appgw-httplistener"
    frontend_ip_configuration_name = "appgw-frontendip"
    frontend_port_name             = "httpPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "appgw-reqroutingrule"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-httplistener"
    backend_address_pool_name  = "appgw-backendpool"
    backend_http_settings_name = "appgw-httpsettings"
    probe_name                 = "appgw-healthprobe"
  }

  tags = {
    Name = "${var.prefix}-${var.environment}-appgw"
  }
}

#################################
# (Optional) HTTPS / SSL Certificate
#################################
# To enable HTTPS, uncomment and provide a PFX:
#
# resource "azurerm_application_gateway_ssl_certificate" "cert" {
#   name      = "appgw-sslcert"
#   data      = base64encode(file(var.ssl_certificate_pfx_path))
#   password  = var.ssl_certificate_password
#   gateway   = azurerm_application_gateway.appgw.name
# }
#
# Then add to the AGW:
# frontend_port { name = "httpsPort"; port = var.load_balancer.listener.port.https }
# http_listener {
#   name                           = "appgw-httpslistener"
#   frontend_ip_configuration_name = "appgw-frontendip"
#   frontend_port_name             = "httpsPort"
#   protocol                       = "Https"
#   ssl_certificate_name           = azurerm_application_gateway_ssl_certificate.cert.name
# }
# And update `request_routing_rule` to point at that listener.

#################################
# (Optional) DNS — Azure DNS Zone & Record
#################################
# If you need DNS in Azure instead of Route 53:
#
# resource "azurerm_dns_zone" "zone" {
#   name                = var.domain_name       # e.g. "yourdomain.com"
#   resource_group_name = var.dns_zone_rg
# }
#
# resource "azurerm_dns_cname_record" "app" {
#   name                = var.dns_record_name   # e.g. "www" or "@"
#   zone_name           = azurerm_dns_zone.zone.name
#   resource_group_name = var.dns_zone_rg
#   ttl                 = 300
#   record              = azurerm_public_ip.appgw.ip_address
# }
