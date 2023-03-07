# resource "aws_ecs_capacity_provider" "cp" {
#   name = "${var.prefix}-cp"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn = aws_autoscaling_group.handson_ci_deploy_asg
#     # managed_termination_protection = "ENABLED"

#     managed_scaling {
#       maximum_scaling_step_size = 1000
#       minimum_scaling_step_size = 1
#       status                    = "ENABLED"
#       target_capacity           = 1
#     }
#   }
# }


resource "aws_ecs_cluster_capacity_providers" "providers" {
  cluster_name = aws_ecs_cluster.cluster.name

  # capacity_providers = [
  #   aws_ecs_capacity_provider.cp.name
  # ]

  # default_capacity_provider_strategy {
  #   capacity_provider = aws_ecs_capacity_provider.cp.name
  #   base              = 1
  #   weight            = 1
  # }

  capacity_providers = [
    "FARGATE"
  ]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

}
