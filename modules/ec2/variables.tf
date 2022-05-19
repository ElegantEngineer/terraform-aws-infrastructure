
variable "ubuntu_version" {
  description = "Ubuntu version"
  type        = string
  default     = "20.04"
}

variable "ami_version" {
  description = "AWS ami version"
  type        = string
  default     = null
}

variable "username" {
  description = "Current username"
  type        = string
}

variable "deployuser" {
  description = "Deploy user username"
  type        = string
  default     = "deploymaster"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet id"
  type        = string
}

variable "key_name" {
  description = "Key name id"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security group ids"
  type        = list(string)
}

variable "instance_count" {
  type        = number
  description = "Instance count"
  default     = 1
}

variable "name" {
  description = "Compute instance name"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "Region name"
  type        = string
}

variable "availability_zone" {
  type        = string
  description = "AWS availability zone"
}

variable "az_number" {
  type        = string
  description = "AWS AZ number"
}

variable "extra_disk" {
  description = "Additional extra disk to attach to the instance"
  type        = map(map(string))
  default     = {}
}

variable "tags" {
  description = "A set of key/value label pairs to assign."
  type        = map(string)
  default     = {}
}