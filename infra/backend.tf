terraform {
  backend "s3" {
    bucket         = "kaiyihuang-tfstate-202507"
    key            = "devops/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
