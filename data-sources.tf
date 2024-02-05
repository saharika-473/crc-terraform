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

data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    sid = "AllowWriteToCloudWatchLogs"
    effect = "Allow"
    actions = [ 
        "logs:CreateLogGroup",
        "logs:CreateLogsStream",
        "logs:PutLogEvents" 
        ]
    resources = [ "${aws_cloudwatch_log_group.LambdaLogs.arn}" ]
  }
}