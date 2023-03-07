resource "aws_codedeploy_app" "app" {
  compute_platform = "ECS"
  name             = "${var.prefix}-app"
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = var.ecs_cluster_name
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  depends_on = [
    data.aws_ecs_cluster.cluster
  ]

  app_name               = aws_codedeploy_app.app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.prefix}-deployment-group"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      //action_on_timeout = "CONTINUE_DEPLOYMENT"
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 5
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          var.alb_listener_prod_arn
        ]
      }

      test_traffic_route {

        listener_arns = [
          var.alb_listener_standby_arn
        ]
      }

      target_group {
        name = var.alb_target_group1_name
      }

      target_group {
        name = var.alb_target_group2_name

      }

    }

  }

}
