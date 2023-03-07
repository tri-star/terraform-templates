variable "prefix" {
  type = string
}

variable "az1" {
  type = string
}

variable "az2" {
  type = string
}


variable "ecr_repo_name" {
  type = string
}

variable "task_definition_arn" {
  type = string
}


variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "alb_listener_prod_arn" {
  type = string
}

variable "alb_listener_standby_arn" {
  type = string
}

variable "alb_target_group1_name" {
  type = string
}

variable "alb_target_group2_name" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "github_https_url" {
  type = string
}

variable "github_repository_name" {
  type = string
}

variable "github_branch_name" {
  type = string
}
