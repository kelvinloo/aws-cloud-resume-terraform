// Generate API gateway
resource "aws_api_gateway_rest_api" "view_count_api" {
  name = "count"
}

resource "aws_api_gateway_resource" "view_count_api" {
  rest_api_id = aws_api_gateway_rest_api.view_count_api.id
  parent_id   = aws_api_gateway_rest_api.view_count_api.root_resource_id
  path_part   = "count"
}

resource "aws_api_gateway_method" "view_count_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.view_count_api.id
  resource_id   = aws_api_gateway_resource.view_count_api.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "aws_api_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.view_count_api.id
  resource_id             = aws_api_gateway_resource.view_count_api.id
  http_method             = aws_api_gateway_method.view_count_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_py.invoke_arn
}

resource "aws_api_gateway_method_response" "view_count_api_method_response" {
  depends_on = [
    aws_api_gateway_method.view_count_api_method
  ]
  rest_api_id = aws_api_gateway_rest_api.view_count_api.id
  resource_id = aws_api_gateway_resource.view_count_api.id
  http_method = aws_api_gateway_method.view_count_api_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "aws_api_gateway_deployment" {
  depends_on  = [aws_api_gateway_method.view_count_api_method, aws_api_gateway_integration.aws_api_gateway_integration]
  rest_api_id = aws_api_gateway_rest_api.view_count_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.view_count_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.aws_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.view_count_api.id
  stage_name    = "prod"
}

// Add permission for API Gateway to access view count Lambda
resource "aws_lambda_permission" "api_to_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_py.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.view_count_api.execution_arn}/*/*"
}

// Usage plan and API key
resource "aws_api_gateway_usage_plan" "myusageplan" {
  name = "my_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.view_count_api.id
    stage  = aws_api_gateway_stage.api_gateway_stage.stage_name
  }

  quota_settings {
    limit  = 50
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 3
    rate_limit  = 5
  }
}

resource "aws_api_gateway_api_key" "mykey" {
  name = "my_key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.mykey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.myusageplan.id
}

