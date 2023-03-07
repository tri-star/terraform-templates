data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "trail" {
  bucket        = "${var.prefix}-trail"
  force_destroy = true
}

data "aws_iam_policy_document" "trail_bucket" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [
      aws_s3_bucket.trail.arn
    ]

    actions = [
      "s3:GetBucketAcl"
    ]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [
      "${aws_s3_bucket.trail.arn}/${var.prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    actions = [
      "s3:PutObject"
    ]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

}

resource "aws_s3_bucket_policy" "trail" {
  bucket = aws_s3_bucket.trail.id
  policy = data.aws_iam_policy_document.trail_bucket.json
}
