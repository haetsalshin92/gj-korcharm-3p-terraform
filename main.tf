terraform {
  backend "s3" {
    bucket = "hsshin-aibotbucket"
    key    = "aibot/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
  }
}