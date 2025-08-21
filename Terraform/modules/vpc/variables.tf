variable "name"    { type = string }
variable "vpc_cidr"{ type = string }
variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}
