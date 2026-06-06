terraform {
  backend "s3" {
    bucket       = "mustafaabukar-devops-tfstate"
    key          = "ecs-project/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
    encrypt      = true
  }
}