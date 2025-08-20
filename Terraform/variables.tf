variable "env"               { type = string }
variable "region"            { type = string  default = "ap-south-1" }
variable "project"           { type = string  default = "three-tier" }
variable "tf_state_bucket"   { type = string }
variable "tf_lock_table"     { type = string }

variable "vpc_cidr"          { type = string  default = "10.1.0.0/16" }
variable "azs"               { type = list(string) default = ["ap-south-1a","ap-south-1b"] }

variable "ec2_instance_type" { type = string  default = "t3.micro" }
variable "desired_capacity"  { type = number  default = 2 }

variable "db_engine"         { type = string  default = "postgres" }
variable "db_engine_version" { type = string  default = "15" }
variable "db_instance_class" { type = string  default = "db.t3.micro" }
variable "db_username"       { type = string  default = "appuser" }
variable "db_password"       { type = string  sensitive = true }

variable "ecr_repo_frontend" { type = string }
variable "ecr_repo_backend"  { type = string }
