resource "aws_s3_bucket" "MyWebsite" {
  bucket = "${local.naming_convention}-frontend"

  force_destroy = var.force_destroy

  tags = var.tags
}
resource "aws_s3_bucket" "MyTerraformBucket" {
  bucket = "${local.naming_convention}-terraform"

  force_destroy = var.force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "MyWebsite" {
  bucket = aws_s3_bucket.MyWebsite.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "MyWebsite" {
  bucket = aws_s3_bucket.MyWebsite.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "MyWebsite" {
  depends_on = [
    aws_s3_bucket_ownership_controls.MyWebsite,
    aws_s3_bucket_public_access_block.MyWebsite,
  ]

  bucket = aws_s3_bucket.MyWebsite.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "frontend_bucket_Policy" {
  bucket = aws_s3_bucket.MyWebsite.id
  policy = data.aws_iam_policy_document.frontend_bucket_Policy.json
}

data "aws_iam_policy_document" "frontend_bucket_Policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.MyWebsite.arn,
      "${aws_s3_bucket.MyWebsite.arn}/*",
    ]
  }
}


resource "aws_s3_bucket_website_configuration" "StaticWebsite" {
  bucket = aws_s3_bucket.MyWebsite.id

  index_document {
    suffix = "index.html"
  }
}

