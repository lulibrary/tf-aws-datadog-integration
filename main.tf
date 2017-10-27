provider "aws" {
    alias = "module"
    profile = "${var.aws_provider_profile}"
    region = "${var.aws_provider_region}"
    assume_role {
        role_arn = "${var.aws_provider_assume_role_arn}"
    }
}

data "aws_iam_policy_document" "dd_cloudtrail_log_bucket_policy" {
    provider = "aws.module"
    statement {
        sid = "DatadogAWSIntegrationPolicyCloudtrailLogBucket"
        actions = [
            "s3:ListBucket",
            "s3:GetBucketLocation",
            "s3:GetObject"
        ]
        resources = [
            "${var.aws_audit_bucket_arn}",
            "${var.aws_audit_bucket_arn}/*"
        ]
        effect = "Allow"
    }
}

data "aws_iam_policy_document" "dd_generic_integration_policy" {
    provider = "aws.module"
    statement {
        sid = "DatadogAWSIntegrationPolicyGeneric"
        actions = [
            "autoscaling:Describe*",
            "budgets:ViewBudget",
            "cloudtrail:DescribeTrails",
            "cloudtrail:GetTrailStatus",
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*",
            "codedeploy:List*",
            "codedeploy:BatchGet*",
            "directconnect:Describe*",
            "dynamodb:List*",
            "dynamodb:Describe*",
            "ec2:Describe*",
            "ec2:Get*",
            "ecs:Describe*",
            "ecs:List*",
            "elasticache:Describe*",
            "elasticache:List*",
            "elasticfilesystem:DescribeFileSystems",
            "elasticfilesystem:DescribeTags",
            "elasticloadbalancing:Describe*",
            "elasticmapreduce:List*",
            "elasticmapreduce:Describe*",
            "es:ListTags",
            "es:ListDomainNames",
            "es:DescribeElasticsearchDomains",
            "kinesis:List*",
            "kinesis:Describe*",
            "lambda:List*",
            "logs:Get*",
            "logs:Describe*",
            "logs:FilterLogEvents",
            "logs:TestMetricFilter",
            "rds:Describe*",
            "rds:List*",
            "route53:List*",
            "s3:GetBucketTagging",
            "s3:ListAllMyBuckets",
            "ses:Get*",
            "sns:List*",
            "sns:Publish",
            "sqs:ListQueues",
            "support:*",
            "tag:getResources",
            "tag:getTagKeys",
            "tag:getTagValues"
        ]
        resources = [
            "*"
        ]
        effect = "Allow"
    }
}

data "aws_iam_policy_document" "dd_assume_role_policy" {
    provider = "aws.module"
    statement {
        sid = "DatadogAWSIntegrationAssumeRolePolicy"
        actions = [
            "sts:AssumeRole"
        ]
        principals {
            type = "AWS"
            identifiers = [
                "arn:aws:iam::${var.datadog_aws_account_id}:root"
            ]
        }
        effect = "Allow"
        condition {
            test = "StringEquals"
            variable = "sts:ExternalId"
            values = [
                "${var.datadog_sts_external_id}"
            ]
        }
    }
}

resource "aws_iam_policy" "dd_account_integration_policy" {
    provider = "aws.module"
    name        = "DatadogAWSIntegrationPolicyGeneric"
    path        = "/"
    description = "DatadogAWSIntegrationPolicyGeneric"
    policy = "${data.aws_iam_policy_document.dd_generic_integration_policy.json}"
}

resource "aws_iam_policy" "dd_account_storage_integration_policy" {
    provider = "aws.module"
    name = "DatadogAWSIntegrationPolicyCloudtrailLogBucket"
    path = "/"
    description = "DatadogAWSIntegrationPolicyCloudtrailLogBucket"
    policy = "${data.aws_iam_policy_document.dd_cloudtrail_log_bucket_policy.json}"
}

resource "aws_iam_role" "dd_account_integration_role" {
    provider = "aws.module"
    name = "DatadogAWSIntegrationRole"
    assume_role_policy = "${data.aws_iam_policy_document.dd_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "allow_dd_account_role" {
    provider = "aws.module"
    role = "${aws_iam_role.dd_account_integration_role.name}"
    policy_arn = "${aws_iam_policy.dd_account_integration_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "allow_dd_account_role_audit" {
    count = "${var.datadog_allow_access_to_audit_bucket}"
    provider = "aws.module"
    role = "${aws_iam_role.dd_account_integration_role.name}"
    policy_arn = "${aws_iam_policy.dd_account_storage_integration_policy.arn}"
}
