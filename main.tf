
module "vpc" {
  source = "./modules/vpc"

  name                 = "network-1"
  description          = "Main network"
  vpc_cidr             = "10.100.0.0/24"
  availability_zone    = var.aws_zone
  az_number            = "a"
  env_name             = "prod"
  tags                 = {
    project     = var.project_name,
    environment = var.env_name
  }
}

module "iam" {
  source          = "./modules/iam"
  public_key_path = var.public_key_path
  project_name    = var.project_name
}

module "web-ec2" {
  source = "./modules/ec2"

  region                 = "eu"
  availability_zone      = var.aws_zone
  az_number              = "a"
  ubuntu_version         = "20.04"
  ami_version            = "ami-06acd502731e7718e"
  subnet_id              = module.vpc.subnet_id
  key_name               = module.iam.project_region_key_pair_id

  vpc_security_group_ids = [
    module.vpc.aws_ssh_security_group_id,
    module.vpc.aws_local_security_group_id,
    module.vpc.aws_web_security_group_id
  ]

  extra_disk = {}

  instance_count = 1
  name           = "web"
  instance_type  = "t2.small"
  env_name       = "prod"
  tags = {
    project     = var.project_name,
    environment = var.env_name
  }

  username   = var.username
  deployuser = var.deployuser

  depends_on = [
    module.vpc
  ]
}

module "backend-ec2" {
  source = "./modules/ec2"

  region                 = "eu"
  availability_zone      = var.aws_zone
  az_number              = "a"
  ubuntu_version         = "20.04"
  ami_version            = "ami-06acd502731e7718e"
  subnet_id              = module.vpc.subnet_id
  vpc_security_group_ids = [module.vpc.aws_ssh_security_group_id, module.vpc.aws_local_security_group_id]

  key_name               = module.iam.project_region_key_pair_id

  extra_disk = {
    "data_storage" = {
      "delete_on_termination" = false
      "volume_size"           = "12"
      "volume_type"           = "gp2"
    }
  }

  instance_count = 1
  name           = "backend"
  instance_type  = "t2.small"
  env_name       = "prod"
  tags = {
    project     = var.project_name,
    environment = var.env_name
  }

  username         = var.username

  depends_on = [
    module.vpc
  ]
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name

  depends_on = [
    module.vpc
  ]
}


output "web-internal_ip_address_this" {
  value = module.web-ec2.private_ip
}

output "web-external_ip_address_this" {
  value = module.web-ec2.public_ip
}

output "backend-internal_ip_address_this" {
  value = module.backend-ec2.private_ip
}

output "backend-external_ip_address_this" {
  value = module.backend-ec2.public_ip
}

output "s3_sa_user_access_key" {
  value = module.s3.s3_sa_user_access_key
}


