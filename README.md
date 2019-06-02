# AWS Terraform Experiment
This repo is just a personal experiment using Terraform for infastructure 
automation on AWS.

## Assumptions
* An AWS user created named terraform with programatic access and AdministratorAccess permissions assigned in IAM.
* We must use the AMI with the ID ami-04a3d424ed14a1996

## Provisioning Software
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


