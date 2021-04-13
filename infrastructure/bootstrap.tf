/* Bootstrap the resources that I'm using to run Terraform. */

resource "aws_s3_bucket" "state" {
  bucket = "luhn-terraform"
  versioning { enabled = true }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "self" {
  name = "self"
}

resource "aws_iam_user_policy_attachment" "self_admin" {
  user       = aws_iam_user.self.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
