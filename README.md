# AWS Cloud Resume Website

Goal: Deploy awebsite with my resume backed by AWS serverless architecture. Implement a CI/CD pipeline using Infrastructure as code so website can be updated remotely over the Internet.
Services used:
•	S3
•	CloudFront
•	Certificate Manager
•	DynamoDB
•	API Gateway
•	Lambda
•	Route 53
•	Terraform
•	GitHub Actions

## AWS architecture
![AWS Diagram](AWS-Diagram.jpg)
 
## HTML/CSS
Wrote resume into a bootstrap template source by davidtmiller: https://github.com/startbootstrap/startbootstrap-resume
Uploaded website files on Amazon S3, tested static website hosting by making bucket public.

## HTTPS/DNS
Purchased a domain name kelvinloo.com from Amazon Route53 and setup CloudFront with S3 as the origin. Created certificate via Certificate Manager and linked it to CloudFront and changed default behaviour to redirect to HTTPS. Set up Hosted Zone entries for domain name and records to use www.kelvinloo.com.
Encountered issue with certificate not validating even after 30 minutes, had to manually edit name servers for the registered domain which resolves the issue.

## JavaScript and View counter
Created a DynamoDB table to store the number of page visits, a Lambda function will process the retrieval of this visit count and update the value stored in DynamoDB. Set up function URL to test by CURLing the function URL and the count updates by 1 correctly on both the table and CURL result. Added a Javascript file to call the API and display on website.
Setup API gateway to front the Lambda function and enabled rate limiting and API key to deter bad actors from abusing API and causing excessive billing on AWS. Set X-API key in Cloudfront origin for the API gateway so CloudFront can call the API when a request is made.

## Infrastructure as Code (Terraform)
Converted architecture to infrastructure as code via Terraform, by reading tutorials online and comparing deployed infrastructure on AWS services I was able to reproduce the same architecture as if I was to manually create the AWS architecture through Amazon console. Terraform easily allows for tear down and rebuild of infrastructure as required, saving costs during development and testing.

## CI/CD pipeline
Made two GitHub repositories, one for the HTML/CSS/Javascript data and the other for Terraform configuration. Added gitignore so AWS access and secret key is not made public and setup a separate private S3 bucket as a backend for storing these secrets instead. 
Created an identity provider on AWS IAM for GitHub to be able to use AWS resources in my AWS account, create a role to allow GitHub access to services required for this deployment. Stored AWS secrets inside GitHub secrets in order for GitHub actions to upload website to S3 bucket on a commit and update Terraform configuration on commit as well.

## Final thoughts
Overall, project was challenging but a good opportunity to test knowledge gained as result of studying and completing Amazon’s solution architect associate certification. Additionally including a github action to destroy the AWS architecture could be added in the future.
Links to related repositories: [frontend](https://github.com/kelvinloo/aws-cloud-resume) / [backend](https://github.com/kelvinloo/aws-cloud-resume-terraform) and the website itself [https://www.kelvinloo.com](https://www.kelvinloo.com)
