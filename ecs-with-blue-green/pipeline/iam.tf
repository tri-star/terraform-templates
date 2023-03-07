resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.prefix}-codepipeline-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codepipeline" {
  name   = "${var.prefix}-codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline.json
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "codestar-connections:UseConnection",
      "ecs:RegisterTaskDefinition",
    ]
  }

  statement {
    effect = "Allow"
    resources = [
      aws_codebuild_project.build_project.arn
    ]

    actions = [
      "codebuild:StartBuild",
      "codebuild:BatchGetBuilds",
    ]
  }

  statement {
    effect = "Allow"
    resources = [
      aws_codedeploy_app.app.arn,
      aws_codedeploy_deployment_group.deployment_group.arn,
    ]

    actions = [
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:CreateDeployment",
      "codedeploy:RegisterApplicationRevision",
    ]
  }

  statement {
    effect = "Allow"
    resources = [
      "arn:aws:codedeploy:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:deploymentconfig:CodeDeployDefault.ECSAllAtOnce"
    ]

    actions = [
      "codedeploy:GetDeploymentConfig",
    ]
  }

  statement {
    effect = "Allow"
    resources = [
      var.ecs_task_execution_role_arn
    ]

    actions = [
      "iam:PassRole",
    ]
  }

}

resource "aws_iam_policy_attachment" "codepipeline_policy" {
  name       = "${var.prefix}-codepipeline-policy"
  policy_arn = aws_iam_policy.codepipeline.arn
  roles      = [aws_iam_role.codepipeline_role.name]
}



resource "aws_iam_role" "codebuild" {
  name               = "${var.prefix}-codebuild-role"
  assume_role_policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOT
}

resource "aws_iam_policy" "codebuild_policy" {
  name   = "${var.prefix}-codebuild-policy"
  policy = data.aws_iam_policy_document.codebuild.json
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecs:DescribeTaskDefinition",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "codestar-connections:UseConnection",
    ]
  }

}


resource "aws_iam_role_policy_attachment" "codebuild" {
  policy_arn = aws_iam_policy.codebuild_policy.arn
  role       = aws_iam_role.codebuild.id
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_power_user_attachment" {
  role       = aws_iam_role.codebuild.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}


resource "aws_iam_role" "codedeploy_role" {
  name               = "${var.prefix}-codedeploy-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "codedeploy_policy" {
  name       = "${var.prefix}-codedeploy-policy"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  roles      = [aws_iam_role.codedeploy_role.name]
}
