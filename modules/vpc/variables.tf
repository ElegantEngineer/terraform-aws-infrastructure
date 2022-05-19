variable "name" {
  description = "VPC name"
  type        = string
}

variable "description" {
  description = "VPC description"
  type        = string
}

variable "tags" {
  description = "A set of key/value label pairs to assign."
  type        = map(string)
  default     = {}
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "Subnet address"
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