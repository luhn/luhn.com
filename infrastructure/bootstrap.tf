/* Bootstrap the resources that I'm using to run Terraform. */

resource "aws_s3_bucket" "state" {
  bucket = "luhn-terraform"
  versioning { enabled = true }
}

resource "aws_iam_user" "self" {
  name = "self"
}

resource "aws_iam_user_policy_attachment" "self_admin" {
  user       = aws_iam_user.self.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
