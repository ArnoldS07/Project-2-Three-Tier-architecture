variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "private_app_subnets" {
  type = list(string)
}

variable "app_sg_id" {
  type = string
}

variable "alb_tg_arn" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "iam_instance_profile" {
  type = string
}

variable "ecr_repo_frontend" {
  type = string
}

variable "ecr_repo_backend" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_pass" {
  type = string
}

variable "db_port" {
  type = number
}
variable "key_name" {
  type        = string
  description = "The name of the EC2 Key Pair to enable SSH access"
}

