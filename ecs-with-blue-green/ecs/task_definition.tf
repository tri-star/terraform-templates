resource "aws_ecs_task_definition" "task_definition" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name   = "app"
      image  = var.ecr_url
      memory = 512
      cpu    = 256
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "TEST"
          value = "VALUE"
        },
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = "app"
          "awslogs-region"        = "us-west-1"
          "awslogs-create-group"  = "true"
          "awslogs-stream-prefix" = "app"
        }
      }
    }
  ])

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
  lifecycle {
    ignore_changes = all
  }

}
