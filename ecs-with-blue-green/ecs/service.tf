resource "aws_ecs_service" "frontend_service" {
  name            = "${var.prefix}-frontend-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  # サービスが失敗続きだったら一個前にデプロイ成功したリビジョンにロールバックする機能
  # deployment_circuit_breaker {
  #   enable   = true
  #   rollback = true
  # }

  # deployment_maximum_percent         = 200
  # deployment_minimum_healthy_percent = 100
  # health_check_grace_period_seconds  = 30

  launch_type = "FARGATE"
  network_configuration {
    subnets = var.subnets
    security_groups = [
      aws_security_group.app_service.id
    ]
    assign_public_ip = true
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app"
    container_port   = 80
  }

  # service_connect_configuration {
  #   enabled = true

  #   namespace = aws_service_discovery_http_namespace.ecs_web_app_handson_namespace.arn

  #   service {
  #     client_alias {
  #       port = 3000
  #     }
  #     port_name = "app"
  #   }
  # }


  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      capacity_provider_strategy,
      load_balancer,
    ]
  }
}
