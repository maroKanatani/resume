data "aws_iam_policy_document" "amplofy_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type    = "Service"
            identifiers =["amplify.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "amplify_build_role" {
  name               = "amplify-build-role"
  assume_role_policy = data.aws_iam_policy_document.amplofy_assume_role.json
}

resource "aws_iam_role_policy_attachment" "resume_amplify_build_attachment" {
  role       = aws_iam_role.amplify_build_role.name
  policy_arn = var.content_accress_policy
}

# Githubリポジトリを参照するAmplifyをTerraformで構築しようとするとエラーになるので、マネコンで認証したものをimportすることで回避する
# see Note: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_app
resource "aws_amplify_app" "resume-app" {
  name       = "resume-app"
  repository = "https://github.com/maroKanatani/resume"

#   enable_auto_branch_creation = true

  # The default patterns added by the Amplify Console.
#   auto_branch_creation_patterns = [
#     "*",
#     "*/**",
#   ]

#   auto_branch_creation_config {
#     # Enable auto build for the created branch.
#     enable_auto_build = true
#   }

  enable_basic_auth      = true
  basic_auth_credentials = base64encode("${var.basic_auth_user}:${var.basic_auth_password}")

  custom_rule {
    source = "/<*>"
    status = "404-200"
    target = "/index.html"
  }

  iam_service_role_arn = aws_iam_role.amplify_build_role.arn

  environment_variables = {
    AMPLIFY_DIFF_DEPLOY = "false"
    AmplifyAMPLIFY_DIFF_BACKEND = "false"
    AMPLIFY_MONOREPO_APP_ROOT = "hugo"
    _LIVE_UPDATES = jsonencode([
      {
        pkg     = "hugo"
        type    = "hugo"
        version = "latest"
      },
    ]),
    CONTENT_BUCKET = var.content_bucket
  }
}
