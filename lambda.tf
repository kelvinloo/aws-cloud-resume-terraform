data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["dynamodb:getItem", "dynamodb:UpdateItem"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

data "archive_file" "python_zip" {
  type        = "zip"
  source_file = "lambdaDynamo.py"
  output_path = "lambdaDynamo_payload.zip"
}

resource "aws_lambda_function" "lambda_py" {
  filename      = "lambdaDynamo_payload.zip"
  function_name = "viewCountLambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambdaDynamo.lambda_handler"
  runtime       = "python3.9"
  depends_on = [
    aws_iam_role.iam_for_lambda
  ]
}