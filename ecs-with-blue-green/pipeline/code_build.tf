data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


resource "aws_codebuild_project" "build_project" {
  name          = "${var.prefix}-build-project"
  description   = "${var.prefix}-build-project"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild.arn

  source {
    type            = "GITHUB"
    location        = var.github_https_url
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
    buildspec = file("./pipeline/buildspec.yml")
  }

  source_version = "refs/heads/main"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "ECR_REPO_NAME"
      value = var.ecr_repo_name
    }

    environment_variable {
      name  = "TASK_DEFINITION_ARN"
      value = var.task_definition_arn
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.prefix}-codebuild"
      stream_name = "build-result"
    }
  }

}
