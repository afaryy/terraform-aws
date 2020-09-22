provider "aws" {
  region =  "ap-southeast-2"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "project-terraform-state-backend-bucket"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
} 

resource "aws_s3_bucket" "project_stack_bucket" {
  bucket = "project-stack-bucket"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
} 

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "project-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}