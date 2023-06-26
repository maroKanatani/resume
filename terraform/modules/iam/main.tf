resource "aws_iam_policy" "policy_allow_ro_access_content_bucket" {
    name = "policy-allow-ro-access-content-bucket"
    policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.content_bucket}",
                "arn:aws:s3:::${var.content_bucket}/*"
            ]
        }
    ]
}
EOT
}

output "policy_arn" {
  value = aws_iam_policy.policy_allow_ro_access_content_bucket.arn
}
