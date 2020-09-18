provider "aws" {
  region            = var.aws_region
  profile           = "default"
  version           = "~> 3.0"
}
