variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "tags" {
  default = {
    Owner   = "Mykhailo Babych"
    Project = "Second Demo"
  }
}
