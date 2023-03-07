
variable "prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type        = list(string)
  description = "サブネットIDの一覧"
}

variable "health_check_path" {
  type = string
}
