variable "gh_username" {
  type        = string
  description = "GitHub Username for GHCR"
}

variable "gh_token" {
  type        = string
  description = "GitHub Token for GHCR"
}

variable "ami_id" {
  default = "ami-03ff09c4b716e6425"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "gj-test2.pem"
}

variable "docdb_uri" {
  type        = string
  description = "DocumentDB connection string"
}

variable "mongodb_username" {}
variable "mongodb_password" {}
variable "mongodb_host" {}
variable "mongodb_port" {
  default = 27017
}
variable "mongodb_database" {}