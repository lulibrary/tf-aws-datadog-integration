# TF - AWS Datadog Integration
Terraform module for defining an AWS role and policy for integrating with Datadog

## Using the module

```[hcl]
module "aws_datadog_integration" {
    source = "github.com/lulibrary/tf-aws-datadog-integration"

    aws_provider_profile = "myproviderprofile"
    aws_provider_region = "eu-west-1"
    aws_provider_assume_role_arn = "arn:aws:iam::111111111111:role/OrganizationAccountAccessRole"

    aws_audit_bucket_arn = "arn:aws:s3:::my_audit_bucket"
    datadog_allow_access_to_audit_bucket = false
    datadog_aws_account_id = "111111111111"
    datadog_sts_external_id = "datadog+external+secret"
}
```

## Input Variables

| Variable | Default | Description |
| --- | --- | --- |
| aws_provider_profile | default | Profile to use from the aws credentials file |
| aws_provider_region | N/A | Region to initialise the provider in |
| aws_provider_assume_role_arn | `Empty String` | ARN of the role to assume for the specified provider |
| aws_audit_bucket_arn | `Empty String` | ARN of the bucket in which cloudtrail logs are stored |
| datadog_allow_access_to_audit_bucket | false | Should the datadog role be able to get objects in the S3 audit bucket, boolean true/false |
| datadog_aws_account_id | N/A | ID of the datadog account to allow assuming the role |
| datadog_sts_external_id | N/A | External ID from datadog for the STS external ID |

## Output Variables

| Variable | Description |
| --- | --- |
| role_arn | ARN of the AWS role created for the datadog integration |