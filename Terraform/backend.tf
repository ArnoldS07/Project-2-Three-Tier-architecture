terraform {
  backend "s3" {
    bucket         = "my-proj-terra-state" 
    key            = "three-tier/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "my-terra-state-lock"
  }
}
