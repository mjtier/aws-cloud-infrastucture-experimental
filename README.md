# AWS Terraform Experiment
This repo is just a personal experiment using Terraform for infastructure 
automation on AWS.

## Assumptions
* We must use the AMI with the ID ami-04a3d424ed14a1996.
    * This AMI must be AWS Linux 2. This will have AWS CLI already installed
* The user has the AWS CLI installed on their machine.
* An AWS user created  with programatic access and AdministratorAccess permissions assigned in IAM.
  The AWS_ACCESS_KEY and AWS_SECRET_KEY must be know for this user.
* The user has Terraform install on their machine. Must be version 0.12.
* The provided Terraform solution will only work in the US-EAST-1 region, as the
  above specified AMI is only present in that region.
* This version requires and S3 bucket mtier.development.terraform.provisioning.
  until the backup scripts could be properly modified to allow for 
  any bucket name.


## Configuration 

### SSH Key

Create an SSH key to be used in AWS key pair. 

`ssh-keygen -f ec2_key`

This, along with our security group automation, will allow us 
to SSH into each running instance in the autoscaling group.

### Create S3 bucket
We need an S3 bucket to pull the configurations from for the dynamically created
ec2 instances in the auto scaling group. 

If this was just a set of instances to spin up, we could just use Terraform's file provisioner 
and remote_exec to provision the instance or use something like Ansible.

Use the AWS CLI locally to create the S3 bucket using the following:

`aws s3 mb s3://<your bucket name>` --region us-east-1`

### Upload the backup script to S3
The script that exports the SQLite database and stores it into S3 bucket is in the 
repository and is called exportdb.sh. Upload this script into your AWS bucket.

### Modify IAM Policy
We must modify the IAM Policy in order for a spun up EC2 instance to access the already created S3 bucket.
Open the policy-s3-bucket.json file and modify the two Resource statements to 
replace `arn:aws:s3:::mjtier.development.terraform.provisioning` with
`arn:aws:s3:::<your bucket name>`.

The policy-s3-bucket.json is pulled in in the main.tf script in the aws_iam_policy
resource. Here I chose to use a seperate .json file rather than dump it all in
the terraform to help with readability.

### Must create your own .tfvars files
The user must create their own .tfvars file to specifiy the following information
that should be secret:
1. AWS_ACCESS_KEY - for terraform user
2. AWS_SECRET_KEY - for terraform user

Note that the .gitignore file ads a configuration to ignore all .tfvars files, so
that we don't accidentlally check in AWS credentials into a GitHub repo.

## Provisioning the Software
There are 2 ways to provision software on an instance. You can bake your own custom AMI
and bundle the desired end state software with the image using a tool like Packer https://packer.io/. 

Another way is to boot a standardized AMI and then install the software on it you need. Normally, for a plain aws_instance terraform resource you install the software by:
* Using file uploads
* Using remote exec 

I use a user_data attribure in the aws_launch_configuration in main.tf. This 
user data runs an initialization for every member of the AutoScaling Group. The
user data for our AWS Launch config is specified in the setup.sh script in this 
repo.




