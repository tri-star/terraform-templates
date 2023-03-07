variable "prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "ecr_url" {
  type = string
}

variable "alb_target_group_arn" {
  type = string
}
