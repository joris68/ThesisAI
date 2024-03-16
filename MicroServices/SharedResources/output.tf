output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_gateway_execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.api.execution_arn
}

output "api_gateway_root_resource_id" {
  description = "The root resource ID of the API Gateway"
  value       = aws_api_gateway_rest_api.api.root_resource_id
}

