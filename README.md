# aws-cloud-infrastucture-experimental

## Assumptions
An AWS user created named terraform with programatic access and AdministratorAccess permissions assigned in IAM.

## Must create your own .tfvars files
The user must create their own .tfvars file to specifiy the following information
that should be secret:
1. AWS_ACCESS_KEY - for terraform user
2. AWS_SECRET_KEY - for terraform user

