# VPC
module "network" {
  source = "./modules/vpc"

  name       = var.name
  prefix     = var.prefix
  cidr_block = var.cidr_block
  az_number  = var.az_number
}

# Consul
module "consul" {
  source = "./modules/ec2"

  name                  = var.name
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  consul_server         = true
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = 1
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}

# Metrics Prod
module "metrics-prod" {
  source = "./modules/ec2"

  env                   = "metrics"
  stage                 = "prod"
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}

# Metrics Test
module "metrics-test" {
  source = "./modules/ec2"

  env                   = "metrics"
  stage                 = "test"
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}

# Logs Prod
module "logs-prod" {
  source = "./modules/ec2"

  env                   = "logs"
  stage                 = "prod"
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}

# Logs Test
module "logs-test" {
  source = "./modules/ec2"

  env                   = "logs"
  stage                 = "test"
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}

# Backups Prod
module "backups-prod" {
  source = "./modules/ec2"

  env                   = "backups"
  stage                 = "prod"
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}

# Backups Test
module "backups-test" {
  source = "./modules/ec2"

  env                   = "backups"
  stage                 = "test"
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}

# App Prod
module "app-prod" {
  source = "./modules/ec2"

  env                   = "app"
  stage                 = "prod"
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}

# App Test
module "app-test" {
  source = "./modules/ec2"

  env                   = "app"
  stage                 = "test"
  prefix                = var.prefix
  datacenter            = var.datacenter
  consul_id             = local.consul_id
  consul_key            = local.consul_key
  os_name               = var.os_name
  instance_architecture = var.instance_architecture
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  subnets               = local.subnets
  security_groups       = local.security_groups
  key_name              = local.key_name
}
