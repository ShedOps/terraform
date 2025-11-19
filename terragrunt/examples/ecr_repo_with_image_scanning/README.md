## Terragrunt Based ECR Repo example with Scanning
## Note: This is WORK IN PROGRESS and is not complete
## You CAN deploy everything as is, and see ECR scan results
## Just the Lambda function is not present yet and "terragrunt run-all plan" won't work yet

This terragrunt based example performs the following, 

* Creates a single ECR repo to house container images

* Enables basic scanning on the repo (OS vulns only)

* 3 x Dockerfiles are provided for testing: good, vulnerable and unsupported

* Creates a EventBridge Rule that captures ECR scan results

* Creates a Lambda function and pipes this into the EventBridge rule (WORK IN PROGRESS)

The Lambda function will do the following, based on the outcome of the ECR scan, received by EventBridge:

* Acquire more detailed information using the payload passed by the ECR scan

* Construct a suitable Teams card

* Send a notification to a specified Teams channel with the customised card


### Walkthrough:

NOTE: THIS SOLUTION WILL COST MONEY!!! I AM NOT RESPONSIBLE FOR THE COST OF YOUR AWS BILL - USE AT YOUR OWN RISK!

* (!) You obviously need an AWS Account and already have programmatical access via awscli (!)

* Install latest terragrunt version

* Install latest terraform version

* Install docker desktop / buildx

* export AWS_DEFAULT_REGION=eu-west-1 (or your choice)

* export TF_VAR_env_file=dev

* Change directory to "resources"

* Execute: terragrunt run-all plan

* If you are happy with the above, execute: terragrunt run-all apply

### Testing:

To test the solution:

TBC
