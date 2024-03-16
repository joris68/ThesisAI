variable "name" {
  description = "ThesisAI API Gateway"
  type        = string
}

variable "description" {
  description = "Handles all API requests from the frontend"
  type        = string
  default     = "Managed by Terraform"
}
