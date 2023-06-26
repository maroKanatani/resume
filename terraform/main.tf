# ----------------------
# Entrypoint
# ----------------------

# Private Contentを格納するためのS3バケットを作成する
module "content_bucket" {
  source = "./modules/s3"
}

module "content_accress_policy" {
  source = "./modules/iam"

  content_bucket = module.content_bucket.bucket
}

module "github" {
  source = "./modules/github"

  github_actions_role_arn = var.github_actions_role_arn
  content_accress_policy = module.content_accress_policy.policy_arn
}

module "amplify_app" {
  source = "./modules/amplify"

  content_bucket      = module.content_bucket.id
  content_accress_policy  = module.content_accress_policy.policy_arn
  basic_auth_user     = var.basic_auth_user
  basic_auth_password = var.basic_auth_password
}
