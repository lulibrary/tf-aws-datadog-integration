output "role_arn" {
    value = "${aws_iam_role.dd_account_integration_role.arn}"
    description = "ARN of the AWS role created for the datadog integration"
}