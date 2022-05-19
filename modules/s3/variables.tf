variable "private-bucket-name" {
  description = "Private bucket name"
  type        = string
  default     = "private-web-storage"
}

variable "public-bucket-name" {
  description = "Public bucket name"
  type        = string
  default     = "public-media-storage"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "is_backup_bucket_needed" {
  description = "Allow and disallow creating backup bucket"
  type        = bool
  default     = true
}