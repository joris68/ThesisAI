

# Define a POST method for register Request
resource "aws_api_gateway_method" "RegisterPost" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.registerResource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Define a resource within the API Gateway for register a user
resource "aws_api_gateway_resource" "registerResource" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root_resource_id
  path_part   = "register"
}


# I can only have a deployment stage if I already have I choose to do that 
# here because we have 

resource "aws_api_gateway_deployment" "deploymentStage" {

  depends_on = [ aws_api_gateway_resource.registerResource ,
  aws_api_gateway_integration.RegisterLambdaIntegration]

  rest_api_id = var.api_gateway_id
  stage_name  = "development" 

  lifecycle {
    create_before_destroy = true
  }

}

#Lambda integration for the API Gateway, integrates the lambda 
resource "aws_api_gateway_integration" "RegisterLambdaIntegration" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.registerResource.id
  http_method = aws_api_gateway_method.RegisterPost.http_method

  integration_http_method = "POST" 
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.RegisterLambda.invoke_arn
}

#lambda execution role for register function
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# attaches rights to write to cloudlogs
resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda_logs_attachment"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "RegisterLambda" {
  function_name = "RegisterLambda"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_exec_role.arn
  runtime       = "nodejs18.x" 
  filename      = "IaCMicros/Register/Lambda/register.zip"

  source_code_hash = filebase64sha256("IaCMicros/Register/Lambda/register.zip")

  environment {
    variables = {
      MongoPassword = var.mongo_password
    }
  }
}

resource "aws_lambda_permission" "api_gateway_invoke_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.RegisterLambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/register/POST"
}

# a log group for my 
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/RegisterLambda"
  retention_in_days = 14

  tags = {
    Name = "LambdaLogGroupForRegisterLambda"
  }
}

