variable "aws_account_id" {
  type = string
  description = "The AWS Account ID"
}

variable "primary_region" {
  type = string
  description = "The primary AWS region"
  default = "ap-northeast-1"
}