resource "null_resource" "install_python_dependencies" {
  provisioner "local-exec" {
    command = "bash ${path.cwd}/scripts/build_package.sh"

    environment = {
      source_code_path = var.path_source_code
      function_name    = var.function_name
      path_module      = path.module
      runtime          = var.runtime
      path_cwd         = path.cwd
    }
  }
}

data "archive_file" "lambda_function_pkg" {
  depends_on    = [null_resource.install_python_dependencies]
  source_dir    = "${path.cwd}/package/lambda_function"
  output_path   = var.output_path
  type          = "zip"
}

resource "aws_lambda_function" "aws_lambda_terminate" {
  function_name    = var.function_name
  description      = "Teminate instances with agedtime less than current time"
  filename         = data.archive_file.lambda_function_pkg.output_path
  handler          = "${var.function_name}.lambda_handler"
  source_code_hash = data.archive_file.lambda_function_pkg.output_base64sha256
  runtime          = var.runtime
  role             = aws_iam_role.lambda_role.arn
  memory_size      = 128
  timeout          = 300
  # layers           = [aws_lambda_layer_version.lambda-layer.arn]
  depends_on       = [null_resource.install_python_dependencies] 
}

/*
resource "aws_s3_bucket_object" "upload" {
 bucket               = var.bucket_name
 key                  = var.s3-deploy-key
 source               = data.archive_file.lambda_function_pkg.output_path
}
*/

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
resource "aws_cloudwatch_log_group" "log_group" {
  name                  = "/aws/lambda/${aws_lambda_function.aws_lambda_terminate.function_name}"
  retention_in_days     = 14
}

resource "aws_cloudwatch_event_rule" "lambda_terminate_rule" {
    name                = "terminate-aged-instance-every-five-minutes"
    description         = "Terminate aged instance every five minutes"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_terminate_target" {
    rule                = aws_cloudwatch_event_rule.lambda_terminate_rule.name
    target_id           = "lambda_terminate_target"
    arn                 = aws_lambda_function.aws_lambda_terminate.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_terminate_instance" {
    statement_id        = "AllowExecutionFromCloudWatch"
    action              = "lambda:InvokeFunction"
    function_name       = aws_lambda_function.aws_lambda_terminate.function_name
    principal           = "events.amazonaws.com"
    source_arn          = aws_cloudwatch_event_rule.lambda_terminate_rule.arn
}