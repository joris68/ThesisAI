


resource "aws_api_gateway_rest_api" "ThesisAIAPI" {
  name        = var.name
  description = var.description

  endpoint_configuration {
    types = ["REGIONAL"]
  }

 
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    aws_api_gateway_rest_api.ThesisAIAPI, 
  ]

  rest_api_id = aws_api_gateway_rest_api.ThesisAIAPI.id
  stage_name  = "development" 

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_secretsmanager_secret" "mySecretManager" {
  name        = "mySecretManager"
  description = "Handles Connectionstrings and so on"

}
