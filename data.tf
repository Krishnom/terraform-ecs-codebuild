data "aws_iam_policy_document" "apps_codepipeline_assumerole_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

  }
}

#data "aws_region" "current" {
#
#}

data "aws_caller_identity" "current" {}
