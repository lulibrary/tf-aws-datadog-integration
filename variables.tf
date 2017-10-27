variable "aws_provider_profile" {
    description = "AWS profile to use for the AWS provider"
    default = "default"
}

variable "aws_provider_region" {
    description = "AWS region to use for the AWS provider"
}

variable "aws_provider_assume_role_arn" {
    description = "ARN of role to assume for the AWS provider"
    default = ""
}

variable "aws_audit_bucket_arn" {
    description ="ARN of the bucket in which cloudtrail logs are stored"
    default = "" 
}

variable "datadog_allow_access_to_audit_bucket" {
    description = "Should the datadog role be able to get objects in the S3 audit bucket"
    default = false
}

variable "datadog_aws_account_id" {
    description = "ID of the datadog account to allow assuming the role"
}

variable "datadog_sts_external_id" {
    description = "External ID from datadog for the STS external ID"
}