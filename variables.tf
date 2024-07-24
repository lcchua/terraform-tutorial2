
variable "stack_name" {
  type    = string
  default = "lcchua-STW"
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = "lcchua-useast1-20072024" # Change accordingly
}

variable "region" {
  description = "Name of aws region"
  type        = string
  default     = "us-east-1"
}