module "trail" {
  source = "./cloud_trail"

  prefix = var.prefix
}

module "vpc" {
  source = "./vpc"

  prefix = var.prefix
  az1    = var.az1
  az2    = var.az2

  depends_on = [
    module.trail
  ]
}

module "alb" {
  source = "./alb"

  prefix  = var.prefix
  subnets = module.vpc.subnet_ids
  vpc_id  = module.vpc.vpc_id

  health_check_path = "/"

  depends_on = [
    module.trail
  ]
}


module "ecs" {
  source = "./ecs"

  prefix  = var.prefix
  subnets = module.vpc.subnet_ids
  vpc_id  = module.vpc.vpc_id

  ecr_url              = var.ecr_url
  alb_target_group_arn = module.alb.alb_target_group1_arn

  depends_on = [
    module.trail
  ]
}

module "pipeline" {
  source = "./pipeline"

  prefix              = var.prefix
  az1                 = var.az1
  az2                 = var.az2
  ecr_repo_name       = var.ecr_repo_name
  task_definition_arn = module.ecs.task_definition_arn

  github_https_url            = var.github_https_url
  github_repository_name      = var.github_repository_name
  github_branch_name          = var.github_branch_name
  ecs_cluster_name            = module.ecs.ecs_cluster_name
  ecs_service_name            = module.ecs.ecs_service_name
  alb_listener_prod_arn       = module.alb.alb_listener_prod_arn
  alb_listener_standby_arn    = module.alb.alb_listener_standby_arn
  alb_target_group1_name      = module.alb.alb_target_group1_name
  alb_target_group2_name      = module.alb.alb_target_group2_name
  ecs_task_execution_role_arn = module.ecs.ecs_task_execution_role_arn

  depends_on = [
    module.trail
  ]
}
