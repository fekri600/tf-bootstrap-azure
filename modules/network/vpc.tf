# ────────── Virtual Network (VN) ──────────
resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-${var.environment}-vnet-${substr(var.location,0,2)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [ var.network.vpc_cidr ]

  tags = {
    Name = "${var.prefix}-${var.environment}-vnet-${substr(var.location,0,2)}"
  }
}

# ────────── Public Subnets ──────────
resource "azurerm_subnet" "public" {
  count               = length(var.network.public_subnets)
  name                = "${var.prefix}-${var.environment}-pub-subnet-${substr(var.network.availability_zones[count.index], -1, 1)}"
  resource_group_name = var.resource_group_name
  virtual_network_name= azurerm_virtual_network.this.name
  address_prefixes    = [ var.network.public_subnets[count.index] ]

  # no NAT on public subnets—VMs get public IPs directly
  # you could also attach a route table here if desired
}

# ────────── Private Subnets ──────────
resource "azurerm_subnet" "private" {
  count               = length(var.network.private_subnets)
  name                = "${var.prefix}-${var.environment}-priv-subnet-${substr(var.network.availability_zones[count.index], -1, 1)}"
  resource_group_name = var.resource_group_name
  virtual_network_name= azurerm_virtual_network.this.name
  address_prefixes    = [ var.network.private_subnets[count.index] ]
}

# ────────── Public IPs for NAT Gateway ──────────
resource "azurerm_public_ip" "nat" {
  count               = length(var.network.public_subnets)
  name                = "${var.prefix}-${var.environment}-nat-ip-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Name = "${var.prefix}-${var.environment}-nat-ip-${count.index}"
  }
}

# ────────── NAT Gateways ──────────
resource "azurerm_nat_gateway" "this" {
  count               = length(var.network.public_subnets)
  name                = "${var.prefix}-${var.environment}-nat-${substr(var.location,0,2)}-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_name                = "Standard"
  public_ip_address_ids   = [ azurerm_public_ip.nat[count.index].id ]

  tags = {
    Name = "${var.prefix}-${var.environment}-nat-${substr(var.location,0,2)}-${count.index}"
  }
}

# ────────── Attach NAT Gateway to Private Subnets ──────────
resource "azurerm_subnet_nat_gateway_association" "private" {
  count             = length(var.network.private_subnets)
  subnet_id         = azurerm_subnet.private[count.index].id
  nat_gateway_id    = azurerm_nat_gateway.this[count.index].id
}

# 