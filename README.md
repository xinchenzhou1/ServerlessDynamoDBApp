# Serverless Museum Rating Application
## Architecture Diagram
The Museum Rating application has the following components:
![museumapp drawio](https://github.com/user-attachments/assets/bf424d6f-15bb-4dd4-ae67-3badaf83115f)
1. A HTML/JavaScript front-end hosted on Amazon S3 for static website hosting.
2. A serverless backend leveraging Amazon API Gateway, AWS Lambda, AWS DynamoDB table.
3. Amazon Cognito user pools is integrated with the frontend and API Gateway for user authentication and API control access.
4. An Amazon CloudFront distribution to serve a static website for content delivery network (CDN). A public certificate for the Amazon CloudFront distributions to configure CloudFront to require that viewers use HTTPS so that connections are encrypted when CloudFront communicates with viewers.
5. A Route53 public hosted zone to route internet traffic for your domain to the CloudFront distribution.
## Application Demo
### Amazon Cognito Integration for API Access Control
![image](https://github.com/user-attachments/assets/65909719-a6c7-46f5-8e33-f4e4f4fac350)
Only Amazon Cognito authenticated users can make API Requests.
### GET Method: Search by Museum Type (e.g. Art, History, Science)
![image](https://github.com/user-attachments/assets/ed692c73-ea70-49bd-b9e8-e5fc904d1963)
Authenticated users can search for museum collections by the museum type using the **search bar**.
### POST Method: Create A Museum Collection
![image](https://github.com/user-attachments/assets/89eb9b9d-d464-4922-a336-29957fc22345)
![image](https://github.com/user-attachments/assets/2c53274e-4071-4dd4-91fe-aecaea2004b3)
Authenticated users can click the "**Add Museum**" button to create a new museum collection by specifiying the following information about the museum:
* name of the museum collection
* name of the museum
* museum rating
* city of the museum
* country of the museum
### PUT Method: Update the Rating for an Existing Museum Collection
![image](https://github.com/user-attachments/assets/c32284b0-380d-40bc-83c1-dd38cc149597)
![image](https://github.com/user-attachments/assets/74447f6f-3c96-41c8-859c-0737c561febb)
Authenticated users can click the "**Edit**" button to update a museum collection rating.
### DELETE Method: Delete a Museum Collection
![image](https://github.com/user-attachments/assets/748c0b7a-95ed-432e-b4b8-80ce0a1bf05b)
![image](https://github.com/user-attachments/assets/8120d0d1-5795-40b6-a2f1-de5d494e5cb0)
Authenticated users can click the "**Delete**" button to delete an existing museum collection.
## Setup the website
### Prerequistes
1. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
2. Have an AWS IAM user account with sufficient permissions to create the necessary resources shown in the architecture diagram.
3. Configure AWS IAM credentials using environment variables [AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).
4. Set up Amazon Route53 by [registering a domain](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html) and make sure the created route53 public zone has the NS and SOA record.
   ![image](https://github.com/user-attachments/assets/d0bedd7d-041e-456b-b9d9-4cea2b7d9ced)
### Deployment with Terraform and configurations
1. Clone the repository:
  ```
  git clone git@github.com:xinchenzhou1/ServerlessDynamoDBApp.git
  cd ServerlessDynamoDBApp/terraform
  ```
2. Fill up the sensitive variable values in terraform.tfvars file: s3_static_bucket_name, test_username, test_password, root_domain_name, sub_domain_name.
3. Run ```terraform init``` to initialize.
4. Run ```terraform plan``` to inspect infrastructure.
5. Run ```terraform apply``` to create infrastructure.
6. Copy the terraform outputs from console when the deployment is complete.
   ![image](https://github.com/user-attachments/assets/9852889c-d55a-4a4f-b9cf-da19d8b60376)
   * Update the **config.js** file under **ServerlessDynamoDBApp/src/frontend** for API endpoint and Cognito User Pool configuration:
   ![image](https://github.com/user-attachments/assets/47024fe2-7546-49f2-95d0-9a4aa5d7881b)
   * ```cd ServerlessDynamoDBApp/src/frontend``` and run the following aws cli command to upload the frontend to the specified S3 bucket:
     ```
     aws s3 sync . s3://{s3_bucket_name}
     ```
7. Optionally, you can load the provided sample museumlist.json data into DynamoDB table by running the LoadMuseumData.py script:
    ```
    python LoadMuseumData.py my-demo-test-museum-db museumlist.json
    ```
8. Run ```terraform destroy``` to clean up.
## Future Work
1. Use Cloudwatch for API Request/Response meta data store.
2. Setup Amazon API Gateway Usage Plan to facilitate rate limiting.
