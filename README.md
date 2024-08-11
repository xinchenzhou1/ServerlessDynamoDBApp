# Serverless Museum Rating Application
## Architecture Diagram
The Museum Rating application has the following components:
![ServerlessDiagram](https://github.com/user-attachments/assets/33bc3557-04f4-4fb7-9a9c-2633b9a7a5c8)
1. A HTML/JavaScript front-end hosted on Amazon S3 for static website hosting.
2. A serverless backend leveraging Amazon API Gateway, AWS Lambda, AWS DynamoDB table.
3. Amazon Cognito user pools is integrated with the frontend and API Gateway for user authentication and API control access.
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
## Deployment with Terraform
1. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Have an AWS IAM user account with sufficient permissions to create the necessary resources shown in the architecture diagram
3. Configure AWS IAM credentials using environment variables [AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
4. Fill up the sensitive variable values in terraform.tfvars file: s3_static_bucket_name, test_username, test_password
5. Run ```terraform init``` to initialize
6. Run ```terraform plan``` to inspect infrastructure
7. Run ```terraform apply``` to create infrastructure
8. Copy the terraform outputs from console
   ![image](https://github.com/user-attachments/assets/463eb40e-19db-4fb8-a333-cf28c5292302)
   * Update the **config.js** file under **ServerlessDynamoDBApp/src/frontend** for API endpoint and Cognito User Pool configuration:
   ![image](https://github.com/user-attachments/assets/47024fe2-7546-49f2-95d0-9a4aa5d7881b)
   * ```cd ServerlessDynamoDBApp/src/frontend``` and run the following aws cli command to upload the frontend to the specified S3 bucket:
     ```
     aws s3 sync $(pwd) s3://{s3_bucket_name}
     ```
<!-- 9. Currently, unfortunately I have to manually enable Cross-Origin Resource Sharing (CORS) in the AWS Console under API Gateway, will try to learn to configure it automatucally with Terraform as part of the future work:
    * Click "**Enable CORS**" button
    ![image](https://github.com/user-attachments/assets/5f73f972-b21c-4178-974d-45a8ec2f0366)
    * Select the following options and click Save
    ![image](https://github.com/user-attachments/assets/ca3f42b0-25b5-4a17-8bc6-bc2a5f13e63a)
    * Click "**Deploy API**" to update and redeploy the APIs:
    ![image](https://github.com/user-attachments/assets/63d0ce9f-b0d1-4c3e-b46c-2ffd8a078dec) -->
9. Optionally, you can load the provided sample museumlist.json data into DynamoDB table by running the LoadMuseumData.py script:
    ```
    python LoadMuseumData.py my-demo-test-museum-db museumlist.json
    ```
10. Run ```terraform destroy``` to clean up
## Future Work
1. Use CloudFront distribution (CDN) to serve a static website with HTTPS for better security practice, and configure Amazon Route 53 to route traffic to the CloudFront distribution.
2. Use Cloudwatch for API Request/Response meta data store. 
