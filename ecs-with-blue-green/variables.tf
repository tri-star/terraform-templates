variable "prefix" {
  type    = string
  default = "ci-deploy"
}


variable "az1" {
  description = "Availability zone"
  type        = string
  default     = "us-west-1a"
}

variable "az2" {
  description = "Availability zone"
  type        = string
  default     = "us-west-1c"
}


variable "ecr_repo_name" {
  description = "ecrリポジトリ名"
  type        = string
}

variable "ecr_url" {
  description = "動作させるコンテナのECR上のURL。 nnnnnnnn.dkr.ecr.us-west-1.amazonaws.com/xxxxxxxx:latest"
  type        = string
}


variable "github_https_url" {
  description = "GitHub上のリポジトリURL"
  type        = string
}

variable "github_repository_name" {
  description = "GitHubのリポジトリ名"
  type        = string
}

variable "github_branch_name" {
  description = "CodePipelineのトリガーとなるブランチ名"
  type        = string
  default     = "main"
}
