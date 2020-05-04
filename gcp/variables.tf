variable "machine_image" {
  description = "GCP machine image ID or family"
  type        = string 
  default     = "cos-cloud/cos-81-12871-59-0" # defaulting to container optimized image
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "zone" {
  type    = string
  default = "us-east1-b"
}

variable "project" {
  description = "GCP project id"
  type        = string
}

variable "agent_instance_type" {
  description = "Relay agent instance type"
  type        = string
  default     = "n1-standard-1"
}

variable "relay_key" {
  description = "Relay access token key, get yours from here https://my.webhookrelay.com/tokens"
  type        = string  
}

variable "relay_secret" {
  description = "Relay access token secret, get yours from here https://my.webhookrelay.com/tokens"
  type        = string
}

variable "relay_buckets" {
  description = "Relay buckets to subscribe to, create yours here https://my.webhookrelay.com/buckets"
  type        = string
}

variable "ssh_access_cidrs" {
  description = "The CIDR blocks that can connect via SSH"
}