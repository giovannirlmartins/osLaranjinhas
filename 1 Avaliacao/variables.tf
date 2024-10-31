variable "s3_bucket_names" {
  type    = list(string)
  default = ["local-files", "bronze", "silver", "gold"]
}

variable "sqs_queue_name" {
  type    = string
  default = "file-upload-queue"
}

variable "sns_topic_name" {
  type    = string
  default = "file-upload-topic"
}
