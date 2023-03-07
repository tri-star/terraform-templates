resource "aws_codestarconnections_connection" "github" {
  name          = "${var.prefix}-github"
  provider_type = "GitHub"
}
