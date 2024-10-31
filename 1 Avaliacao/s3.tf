resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.s3_bucket_names)
  bucket   = each.value
}

output "s3_buckets" {
  value = [for bucket in aws_s3_bucket.buckets : bucket.bucket]
}

resource "aws_s3_bucket_notification" "bucket_notifications" {
  for_each = { for k, v in aws_s3_bucket.buckets : k => v if k != "local-files" }

  bucket = each.value.id

  topic {
    topic_arn = aws_sns_topic.file_upload_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
