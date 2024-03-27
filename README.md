# Cloud Resume Challenge - AWS Infrastructure as Code (IaC) 
This repository contains the Terraform configuration for deploying the
infrastructure behind a cloud-based resume website built using the AWS
Cloud Resume Challenge.

## What's included?

* Terraform modules to provision the following AWS resources: 
    - S3 Bucket for static website hosting 
    - CloudFront distribution for content delivery
    - ACM Certificate for HTTPS encryption (optional) 
    - Route 53 Hosted Zone for DNS management (optional)
    - Additional resources can be added based on your specific implementation (e.g., DynamoDB for a visitor counter)

## Prerequisites:

* An AWS account with appropriate permissions
* Terraform installed and configured (refer to https://www.terraform.io/ for installation)

## Deployment:

1. Clone this repository:
```
git clone repository URL
```
2. Replace the placeholder values in terraform.tfvars with your desired configurations (e.g., domain name, website bucket name).

3. Initialize Terraform:
```
cd crc-terraform
terraform init
```
4. Plan the infrastructure deployment: 
```
terraform plan
```
5. Review the plan and apply the infrastructure if satisfied:
terraform apply 

## Additional Notes:

* This is a base configuration and can be extended to include additional AWS resources as needed for your cloud resume implementation.
* Consider implementing version control for your Terraform configurations using Git version control.
* For a complete Cloud Resume Challenge experience, you'll need to develop the front-end website files and potentially additional backend logic depending on your desired features. 

## Resources:

* Cloud Resume Challenge: https://m.youtube.com/watch?v=b8imSRcY0eo
* Terraform by HashiCorp: https://www.terraform.io/

## Feel free to contribute!

* This is a starting point, and improvements are always welcome.
* If you've added functionalities or have suggestions, consider creating a pull
request to share your enhancements.
