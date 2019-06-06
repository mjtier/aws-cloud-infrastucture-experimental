# AWS Terraform Experiment
This repo is just a personal experiment using Terraform for infastructure 
automation on AWS.

## Assumptions
* An AWS user created named terraform with programatic access and AdministratorAccess permissions assigned in IAM.
* We must use the AMI with the ID ami-04a3d424ed14a1996

## Provisioning the Software
There are 2 ways to provision software on an instance. You can bake your own custom AMI
and bundle the desired end state software with the image using a tool like Packer https://packer.io/. 

Another way is to beeot a standardized AMI and then install the software on it you need. You can 
install the software by:
* Using file uploads
* Using remote exec 
* Using a software provising and configuration management tool like Ansible




## Must create your own .tfvars files
The user must create their own .tfvars file to specifiy the following information
that should be secret:
1. AWS_ACCESS_KEY - for terraform user
2. AWS_SECRET_KEY - for terraform user

Note that the .gitignore file ads a configuration to ignore all .tfvars files, so
that we don't accidentlally check in AWS credentials into a GitHub repo.


## SSH Key

Create an SSH key to be used in AWS key pair. 

`ssh-keygen -f ec2_key`

This will along with our security group automation will allow us 
to SSH into each running instance in the autoscaling group.

## Creat a configuration S3 bucket 
We need an S3 bucket to pull the configurations from for the dynamically created
ec2 instances in the auto scaling group.

`aws s3 mb s3://scripts --region us-east-1`


## S3 Bucket Creattion
The terraform file s3.tf creates the S3 bucket to store the cache snapshots.
