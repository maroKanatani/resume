# ----------------------
# Config
# ----------------------
terraform {
  required_version = "1.5.6"

  required_providers {
    aws = {
      version = "5.94.1"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    # 手動で作成したS3バケット
    bucket = "terraform-state-20230622130934663800000001"
    key    = "resume-development/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
