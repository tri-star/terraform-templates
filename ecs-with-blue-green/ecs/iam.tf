resource "aws_iam_role" "ecs_role" {
  name               = "${var.prefix}-ecs-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "ecs_policy" {
  name       = "${var.prefix}-ecs-policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  roles      = [aws_iam_role.ecs_role.name]
}


resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.prefix}-instance-profile"
  role = aws_iam_role.ecs_role.name
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.prefix}-ecs-task-execution-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "${var.prefix}-ecs-task-execution-policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}

data "aws_iam_policy_document" "ecs_task_logging" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
    ]
  }
}

resource "aws_iam_policy" "ecs_task_logging" {
  name   = "${var.prefix}-ecs-task-logging"
  policy = data.aws_iam_policy_document.ecs_task_logging.json
}

resource "aws_iam_policy_attachment" "ecs_task_logging" {
  name       = "${var.prefix}-ecs-task-logging"
  policy_arn = aws_iam_policy.ecs_task_logging.arn
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}
