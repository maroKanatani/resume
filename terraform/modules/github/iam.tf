variable "github_actions_role_arn" {
  type = string
}

# ------------------------------------------------------------------------------
# GitHub Actions Role
# ------------------------------------------------------------------------------
resource "aws_iam_role" "resume_github_actions" {
  name               = "resume-github-actions"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      identifiers = [var.github_actions_role_arn]
      type        = "Federated"
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:maroKanatani/resume:*"]
    }
  }
}

# ------------------------------------------------------------------------------
# resume PDF Build Policy
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy" "resume_pdf_build" {
  name   = "resume-pdf-build"
  role   = aws_iam_role.resume_github_actions.id
  policy = data.aws_iam_policy_document.resume_pdf_build.json
}

data "aws_iam_policy" "AmazonS3ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "resume_pdf_build_attachment" {
  name       = "resume-pdf-build-attachment"
  roles      = [aws_iam_role.resume_github_actions.name]
  policy_arn = data.aws_iam_policy.AmazonS3ReadOnlyAccess.arn
}
