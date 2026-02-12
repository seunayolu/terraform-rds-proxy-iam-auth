data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_instance_iam_policy" {
  statement {
    actions = [
      "rds-db:connect",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.rds_proxy_prx_id}/node_app",
      "arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.rds_proxy_prx_id}/node_user",
      "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter/dev/database/*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "rds_proxy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "rds_proxy_iam_policy" {
  statement {
    actions = [
      "rds-db:connect"
    ]
    resources = [
      "arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.rds_dbi}/node_app",
      "arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.rds_dbi}/node_user"
    ]
    effect = "Allow"
  }
}