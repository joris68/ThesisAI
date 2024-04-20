
provider "aws" {
  region     = "eu-central-1" 
}


# ThesisAIAPI is the name in my terraform configuration
# name attribute is the actual name in AWS

resource "aws_api_gateway_rest_api" "ThesisAIAPI" {
  name        = "ThesisAIAPI"
  description = "REST API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

 
}



# importing the Register Microservice
#set the right variables for the needed services
module "RegisterMicroservice" {
  source                     = "./IaCMicros/Register"
  mongo_password = ""
  api_gateway_id                = aws_api_gateway_rest_api.ThesisAIAPI.id
  api_gateway_execution_arn  = aws_api_gateway_rest_api.ThesisAIAPI.execution_arn
  api_gateway_root_resource_id = aws_api_gateway_rest_api.ThesisAIAPI.root_resource_id
}


