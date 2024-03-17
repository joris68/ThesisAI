variable "api_gateway_id" {
  description = "Id of the API Gateway"
}


variable "api_gateway_execution_arn" {

     description = "arn of the API Gateway"
  
}

variable "api_gateway_root_resource_id" {
  description = "root resource Id from the "
}

variable "mongo_password" {
  type      = string
  sensitive = true
}