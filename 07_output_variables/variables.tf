# If no type is specified, then Terraform assumes a variable is a string. 
variable "project" {
  type = string
  default = "Project ID"
}

# Path is relative to the location where terraform is running.
variable "credentials_file" {
  default = "<NAME>.json"
}


variable "region" {
  default = "asia-northeast3"
}

variable "zone" {
  default = "asia-northeast3-c"
}

variable "environment" {
  type = string 
  default = "dev"
}

variable "machine_types" {
  type = map
  default = {
    "dev" = "f1-micro"
    "test"  = "n1-highcpu-32"
    "prod"  = "n1-highcpu-32"
  }
}
