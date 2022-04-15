variable "cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  default = ["10.0.11.0/24", "10.0.22.0/24"]
}

variable "availability_zones" {
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "environment" {
  default = "demo"
}
