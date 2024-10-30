provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "localFiles" {
  bucket = "localFiles200024"

  tags = {
    Name        = "localFiles"
    Environment = "Dev"
    Managedby = "Terraform"
  }
}

resource "aws_s3_bucket" "bronze" {
  bucket = "bronze200024"

  tags = {
    Name        = "bronze"
    Environment = "Dev"
    Managedby = "Terraform"
  }
}

resource "aws_s3_bucket" "silver" {
  bucket = "silver200024"

  tags = {
    Name        = "silver"
    Environment = "Dev"
    Managedby = "Terraform"
  }
}

resource "aws_s3_bucket" "gold" {
  bucket = "gold200024"

  tags = {
    Name        = "gold"
    Environment = "Dev"
    Managedby = "Terraform"
  }
}

resource "aws_sns_topic" "file_notifications" {
  name = "file-upload-notifications"
}

resource "aws_sqs_queue" "file_notification_queue" {
  name = "file-notification-queue"
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.file_notifications.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.file_notification_queue.arn
}



resource "aws_s3_bucket_notification" "bronze_notification" {
  bucket = aws_s3_bucket.bronze.bucket

  topic {
    topic_arn = aws_sns_topic.file_notifications.arn
    events    = ["s3:ObjectCreated:*"]
  }
}


resource "aws_s3_bucket_notification" "silver_notification" {
  bucket = aws_s3_bucket.silver.bucket

  topic {
    topic_arn = aws_sns_topic.file_notifications.arn
    events    = ["s3:ObjectCreated:*"]
  }
}


resource "aws_s3_bucket_notification" "gold_notification" {
  bucket = aws_s3_bucket.gold.bucket

  topic {
    topic_arn = aws_sns_topic.file_notifications.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
