variable "owner_email" {
  default = "jon.boydell@massive.co"
}

variable "project_name" {
}

variable "cidr_map" {
  type = "map"
  default = {
    massive_london = "31.221.79.50/32"
    massive_prague = ""
    the_internet = "0.0.0.0/0"
  }
}