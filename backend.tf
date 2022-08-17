#
#terraform {
#  backend "s3" {
#    bucket = "krisnom-terraform-state-buckets" //Rename the name with the prefix "demo-project" with name provided in backend
#    key    = "terraform.tfstate"
#    region = "us-east-1" // AWS Region in which state bucket is created
#  }
#}
