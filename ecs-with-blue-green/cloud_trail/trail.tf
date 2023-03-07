resource "aws_cloudtrail" "trail" {
  name           = "${var.prefix}-trail"
  s3_bucket_name = aws_s3_bucket.trail.id
  s3_key_prefix  = var.prefix
  # event_selector {
  #   read_write_type           = "All"
  #   include_management_events = true

  #   data_resource {
  #     type   = "AWS::Lambda::Function"
  #     values = ["arn:aws:lambda"]
  #   }
  # }
}
