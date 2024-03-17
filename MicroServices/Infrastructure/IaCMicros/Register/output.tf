



output "api_gateway_deployment_id" {
  description = "The ID of the API Gateway Deployment"
  value       = aws_api_gateway_deployment.deploymentStage.id
}



output "api_gateway_invoke_url" {
  description = "The invoke URL of the API Gateway for the development stage"
  value       = "https://${var.api_gateway_id}.execute-api.eu-central-1.amazonaws.com/development"
}