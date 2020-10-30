terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}


/*
terraform {
  backend "s3" {
    # enable remote state storage with S3
    bucket         = "project-terraform-state-backend-bucket"
    key            = "${prefix}/terraform.tfstate"
    region         = "ap-southeast-2"

    # use DynamoDB for locking with Terraform
    dynamodb_table = "project-terraform-locks" # create a DynamoDB table that has a primary key called LockID
    encrypt        = true
  }
}
*/


