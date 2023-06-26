resource "aws_s3_bucket" "resume" {
  bucket_prefix = "resume-private-content"
}

resource "aws_s3_bucket_public_access_block" "resume" {
  bucket = aws_s3_bucket.resume.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "resume" {
  bucket = aws_s3_bucket.resume.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "id" {
  value = aws_s3_bucket.resume.id
}

output "bucket" {
  value = aws_s3_bucket.resume.bucket
}