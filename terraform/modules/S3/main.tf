resource "aws_s3_bucket" "bucket"{
    bucket = var.s3_bucket_name
    force_destroy = true
}

# enable public access to bucket for static website hosting
resource "aws_s3_bucket_public_access_block" "bucket_access_block"{
    bucket = aws_s3_bucket.bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.bucket_access_block]
  bucket     = aws_s3_bucket.bucket.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "PublicReadGetObject",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
        }
      ]
    }
  )
}

# # uploads all the files present under ../../../src/content folder to the S3 bucket
# resource "aws_s3_object" "upload_object"{
#     for_each = fileset("../src/content/", "**/*")
#     bucket = aws_s3_bucket.bucket.id
#     key = each.value
#     source = "../src/content/${each.value}"
#     etag = filemd5("../src/content/${each.value}")
#     content_type  = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
# }

# enable static website hosting
resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }
}
