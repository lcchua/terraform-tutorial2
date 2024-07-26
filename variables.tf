
variable "stack_name" {
  type    = string
  default = "lcchua-STW"
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = "lcchua-useast1-20072024" #
}

variable "region" {
  description = "Name of aws region"
  type        = string
  default     = "us-east-1"
}

variable "az1" {
  description = "Name of availability zone 1"
  type        = string
  default     = "us-east-1d"
}

variable "az2" {
  description = "Name of availability zone 21"
  type        = string
  default     = "us-east-1e"
}