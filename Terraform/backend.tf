terraform {
  backend "s3" {
    bucket       = "rds-iam-auth-tfstate"
    key          = "tf-iam-auth/state.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}