# SNS Topic
resource "aws_sns_topic" "file_upload_topic" {
  name = var.sns_topic_name
}

# SQS Queue
resource "aws_sqs_queue" "file_upload_queue" {
  name = var.sqs_queue_name
}

# SQS Subscription to SNS Topic
resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.file_upload_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.file_upload_queue.arn
}

# Permitir SNS publicar mensagens para SQS
resource "aws_sqs_queue_policy" "sns_to_sqs_policy" {
  queue_url = aws_sqs_queue.file_upload_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "SQS:SendMessage"
        Resource = aws_sqs_queue.file_upload_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.file_upload_topic.arn
          }
        }
      }
    ]
  })
}
