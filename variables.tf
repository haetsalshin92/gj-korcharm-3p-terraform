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
  default = "gj-test2"
}
