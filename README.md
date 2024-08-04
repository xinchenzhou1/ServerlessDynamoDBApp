# Serverless Museum Rating Application
1. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Have an AWS IAM user account with sufficient permissions to create the necessary resources shown in the architecture diagram
3. Configure AWS IAM credentials using environment variables [AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
4. Fill up the sensitive variable values in terraform.tfvars file
5. Run ```terraform init``` to initialize
6. Run ```terraform plan``` to inspect infrastructure
7. Run ```terraform apply``` to create infrastructure
8. Copy the following outputs: ![image](https://github.com/user-attachments/assets/463eb40e-19db-4fb8-a333-cf28c5292302)
9. Click Enable CORS in API Gateway Console under resources to enable CORS: ![image](https://github.com/user-attachments/assets/5f73f972-b21c-4178-974d-45a8ec2f0366)
10. Select the following options and click Save: ![image](https://github.com/user-attachments/assets/ca3f42b0-25b5-4a17-8bc6-bc2a5f13e63a)
11. Click Deploy API to update and deploy the APIs: ![image](https://github.com/user-attachments/assets/63d0ce9f-b0d1-4c3e-b46c-2ffd8a078dec)
12. Run ```terraform destroy``` to clean up
