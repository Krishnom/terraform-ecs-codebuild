resource "aws_codestarconnections_connection" "repo_connection" {
  name          = var.project_repository_name
  provider_type = var.codestar_provider_type
}

resource "aws_codepipeline" "app_pipeline" {
  name     = var.ecs_app_service_name
  role_arn = aws_iam_role.apps_codepipeline_role.arn
  tags     = merge(local.default_tag, var.tags)
  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category      = "Source"
      configuration = {
        "ConnectionArn"    = coalesce(aws_codestarconnections_connection.repo_connection.arn, aws_codestarconnections_connection.repo_connection.arn)
        "FullRepositoryId" = format("%s/%s", var.project_repository_owner, var.project_repository_name)
        "BranchName"       = var.project_repository_branch
      }
      input_artifacts  = []
      name             = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeStarSourceConnection"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category      = "Build"
      configuration = {
        "ProjectName" = "${var.environment_name}-${var.ecs_app_service_name}"
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name             = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      category      = "Deploy"
      configuration = {
        "ClusterName" = aws_ecs_cluster.main.name
        "ServiceName" = aws_ecs_service.app.name
        #"DeploymentTimeout" = "15"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name             = "Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "ECS"
      run_order        = 1
      version          = "1"
    }
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.environment_name}-${var.ecs_app_service_name}-codepipeline-artifactes"
}


resource "aws_iam_role" "codepipeline_role" {
  name = "${var.environment_name}-${var.ecs_app_service_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${aws_codestarconnections_connection.repo_connection.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
#
#data "aws_kms_alias" "s3kmskey" {
#  name = "alias/${var.environment_name}-${var.ecs_app_service_name}-KmsKey"
#}
