terraform {
  backend "s3" {
    bucket              = "caat-portfolio-terraform-state-530142862811"
    key                 = "enterprise-cloud-portfolio/terraform.tfstate"
    region              = "us-east-1"
    encrypt             = true
    use_lockfile        = true
    allowed_account_ids = ["530142862811"]
  }
}