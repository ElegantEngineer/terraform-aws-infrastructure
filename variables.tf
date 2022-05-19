variable "aws_access_key_id" {
  description = "AWS access key id"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_folder_id" {
  description = "AWS Cloud Folder ID where resources will be created"
  type        = string
  default     = ""
}

variable "aws_zone" {
  description = "AWS Cloud compute default zone"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "project-1"
}

variable "env_name" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "public_key_path" {
  description = "Public key path"
  type        = string
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