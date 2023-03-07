resource "aws_s3_bucket" "artifact" {
  bucket        = "${var.prefix}-artifact"
  force_destroy = true
}
