### The Vistor Count Project

In this project, we will build a containerized flask app that connects with redis database. We will build a docker image for the flask app and push it to AWS Elastic Container Registry (ECR). We will write the kubernetes code to deploy the flask app and redis on the EKS cluster. We will write the CI/CD pipeline code in the .gitlab-ci.yml file. The CI/CD pipeline will be triggered when we push the code to the main branch. We will use the following tools in the CI/CD pipeline: terraform, bandit, docker, trivy, and kubectl. We will deploy the flask app and redis on the EKS cluster. We will create two services within in the same namespace - redis service with type ClusterIP and flask service with type NodePort. The flask app will be available outside the cluster using the NodePort service on the port 30080. The flask app will connect with redis using the redis service name on port 6379.

### Tech Stack
- AWS for infrastructure
- Terraform for infrastructure provisioning
- Docker for containerization
- ECR for artifact repository
- Kubernetes for container orchestration (EKS)
- Flask for web application
- Redis for database
- Gitlab for CI/CD

### Project Structure
```
├── README.md
├── app
│   ├── Dockerfile
│   ├── app.py
│   ├── requirements.txt
│
├── iac
│   ├── provider.tf
│   ├──variables.tf
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── routing.tf
│   ├── random.tf
│   ├── ecr.tf
│   ├── eks-controlplane.tf
│   ├── eks-iam-cprole.tf
│   ├── eks-workernode.tf
│   ├── eks-iam-wnrole.tf
│   ├── outputs.tf
│
├── assests
│   
├── .gitlab-ci.yml
├── .gitignore
```

### Architecture Diagram

![Architecture Diagram](https://github.com/rajeshdevopsaws/visitor-app-eks-devops-end2end/tree/main/assets/Architecture.png)


### Project Description

#### 1. Infrastructure as Code

Terraform is open-source infrastructure as code software tool created by HashiCorp. Users define and provision data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

The infrastructure is provisioned on AWS using terraform. The terraform code creates the following resources on AWS:
        - VPC
        - Subnets
        - Internet Gateway
        - Route Table
        - Security Group
        - EKS Cluster
        - EKS Node Group with 2 nodes
        - ECR Repository
        - IAM Roles and Policies for EKS Cluster and EKS Node Group
We have deployed all the resources in the ap-south-1 region of AWS. We have create two worker nodes for high availability. 

#### 2. Containerization

Docker is a set of platform as a service (PaaS) products that use OS-level virtualization to deliver software in packages called containers. Containers are isolated from one another and bundle their own software, libraries and configuration files.

We have built a containerized flask app that connects with redis database. The flask app is a simple web application that displays the number of times the page has been viewed. The flask app connects with redis database to store the number of times the page has been viewed.

We have built a docker image for the flask app and pushed it to AWS Elastic Container Registry (ECR). ECR is our artifact repository.


#### 3. Container Orchestration

Kubernetes is an open-source container-orchestration system for automating computer application deployment, scaling, and management. It was originally designed by Google and is now maintained by the Cloud Native Computing Foundation.

We have written the kubernetes code to deploy the flask app and redis on the EKS cluster. The flask app and redis are deployed as pods on the EKS cluster. The flask app is exposed as a service on port 3000. The redis is exposed as a service on port 6379. The flask app connects with redis using the redis service name. The flask app is deployed as a deployment with 2 replicas. The redis is deployed as a deployment with 1 replica. The flask app and redis are deployed in the same namespace.

We created two services within in the same namespace.

- Redis service with type ClusterIP
- Flask service with type NodePort

The flask app is available outside the cluster using the NodePort service on the port 30080. The flask app connects with redis using the redis service name on port 6379.

#### 4. CI/CD

GitLab is a web-based DevOps lifecycle tool that provides a Git-repository manager providing wiki, issue-tracking and CI/CD pipeline features, using an open-source license, developed by GitLab Inc.

We have written the CI/CD pipeline code in the .gitlab-ci.yml file. The CI/CD pipeline is triggered when we push the code to the non release branch. 

![CI Stages NoN Release](https://github.com/rajeshdevopsaws/visitor-app-eks-devops-end2end/blob/main/assets/CI-Stages-non-release.png?raw=true)


For the release branch, we have added additional stages to the CI/CD pipeline such as building and pushing the docker image to ECR. 
The release branch is in the format of v.x.x.x such as v.1.0.0

![CI Stages Release](https://github.com/rajeshdevopsaws/visitor-app-eks-devops-end2end/blob/main/assetsCI-Stages-release.png?raw=true)

Once release is triggered using the release branch. Then deployment to sit, uat and prod can be done using the manual trigger.
![CI Stages Release](https://github.com/rajeshdevopsaws/visitor-app-eks-devops-end2end/blob/main/assetsDeploy.png?raw=true)

We have added 3 variables in the GitLab project settings.
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_DEFAULT_REGION
This variables are used to configure the awscli in the CI/CD pipeline. Ensure that the user has the required permissions to provision the infrastructure on AWS along with the required permissions to push the docker image to ECR and deploy the flask app and redis on the EKS cluster.

We have defined the following stages in the CI/CD pipeline:

  - terraform_validate
  - terraform_plan
  - terraform_deploy
  - python_bandit_scan
  - docker_build_deploy
  - trivy_scan
  - eks_deploy_sit
  - eks_deploy
  - environment_cleanup_sit
  - environment_cleanup

This stages are executed based on the branch name. The stages prefixed with sit are executed when we push the code to the sit branch. The stages prefixed with man are executed when we push the code to the main branch. Sit branch is used for testing. Main branch is used for production. Similarly, we can create branches for other environments like UAT, DEV, etc. We can also create branches for feature development. We can also create branches for bug fixes. We can also create branches for hot fixes. 

Refer the .gitlab-ci.yml file for more details.

We have used the following tools in the CI/CD pipeline:

- terraform
- bandit
- docker
- trivy
- kubectl

Let's look at each stage in detail.

### Before Script

In the global and local before_script, we have installed curl, awscli, kubectl, terraform, bandit, docker, trivy, and pip. We have also configured the awscli with the access key and secret key. We have also configured the awscli with the region ap-south-1.

##### terraform_validate

In this stage, we validate the terraform code using the terraform validate command.

##### terraform_plan

In this stage, we plan the terraform code using the terraform plan command.

##### terraform_deploy

In this stage, we deploy the terraform code using the terraform apply command.

We are leverage the AWS S3 backend to store the terraform state file. We have created a S3 bucket named `visitor-terraform-state-bucket`. We have created a DynamoDB table named `visitor-state-lock-dynamo`. We have configured the terraform backend to use the S3 bucket and DynamoDB table.

To create the S3 bucket and DynamoDB table, we have used the following terraform code:


```hcl
resource "aws_s3_bucket" "tf_course" {
    bucket = "visitor-terraform-state-bucket"
}
```

```hcl
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "visitor-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 1
  write_capacity = 1
 
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

> The S3 bucket name should be globally unique. So, please change the S3 bucket name in the terraform code, if you are planning to use the same code.

The LockID attribute is used to uniquely identify a lock item. The LockID attribute is used to prevent multiple users from running terraform apply at the same time. The LockID attribute is used to prevent multiple users from running terraform destroy at the same time.

The terraform s3 backend stores the terraform state file in the S3 bucket. The terraform s3 backend uses the DynamoDB table to lock the state file. The terraform s3 backend uses the DynamoDB table to prevent multiple users from running terraform apply at the same time. The terraform s3 backend uses the DynamoDB table to prevent multiple users from running terraform destroy at the same time.

```hcl
terraform {
  backend "s3" {
    bucket = "visitor-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "visitor-state-lock-dynamo"
    encrypt = true
  }
}
```


Once the terraform code is deployed, we will have our Artifactory (ECR) and EKS cluster ready.

##### python_bandit_scan

Security should be a top priority when developing applications. We have used Bandit to scan the python code for security vulnerabilities. Bandit is a tool designed to find common security issues in Python code.

Bandit is a tool designed to find common security issues in Python code. 

Once the bandit scan is completed, we will have the results in the GitLab pipeline. We can also download the results in the form of a JSON file.

##### docker_build_deploy

In this stage, we build the docker image for the flask app and push it to the ECR repository. 

We have logged in to the ECR repository using the aws ecr get-login-password command. We have built the docker image using the docker build command. We have tagged the docker image using the docker tag command. We have pushed the docker image to the ECR repository using the docker push command.

##### trivy_scan

Container images are a critical part of the modern software supply chain. We have used Trivy to scan the docker image for security vulnerabilities. Trivy is a simple and comprehensive vulnerability scanner for containers.

In this stage, we scan the docker image using the trivy image command. 
We can also download the results in the form of a JSON file.

##### eks_deploy

In this stage, we deploy the flask app and redis on the EKS cluster. We have used the kubectl apply command to deploy the flask app and redis on the EKS cluster. 


We have deployed the flask app as a deployment with 2 replicas. We have deployed the redis as a deployment with 1 replica. 

We have created two services within in the same namespace - redis service with type ClusterIP and flask service with type NodePort. The flask app is available outside the cluster using the NodePort service on the port 30080. The flask app connects with redis using the redis service name on port 6379.

But the flask app is not accessible outside the cluster. We need to configure the security group to allow traffic on port 30080. Since we have deployed the flask app on the worker nodes, we need to configure the security group of the worker nodes to allow traffic on port 30080. 

Usage of the NodePort service is not recommended in production. We should use the LoadBalancer service in production. The LoadBalancer service will create a load balancer in AWS and route the traffic to the worker nodes. The LoadBalancer service will also configure the security group to allow traffic on port 30080.

As part of the assignment, we have used the NodePort service to expose the flask app outside the cluster. We have configured the security group of the worker nodes to allow traffic on port 30080.


### How to Access the Application

We can access the flask app using the NodePort service on the port 30080. We can get the public IP of the worker node using the following command:

```bash
aws ec2 describe-instances --filters "Name=tag:eks:nodegroup-name,Values=worker-group-*" --query "Reservations[*].Instances[*].[PublicIpAddress]"   --output text | awk '{print $0":30080"}'
```

We can access the flask app using the public IP of the worker node on the port 30080.

```bash
http://<public-ip>:30080
```

Example:

```bash
http://52.38.11.45:30080
```

### Environment Cleanup

In this stage, we destroy the terraform code using the terraform destroy command. We have used the -auto-approve flag to automatically approve the terraform destroy command. This stage should be used with caution. This stage setup is made to trigger manually in the GitLab pipeline. This stage should not be triggered automatically in UAT or PROD environments.


### Conclusion

We have successfully built a containerized flask app that connects with redis database. We have built a docker image for the flask app and pushed it to AWS Elastic Container Registry (ECR). We have written the kubernetes code to deploy the flask app and redis on the EKS cluster. We have written the CI/CD pipeline code in the .gitlab-ci.yml file. The CI/CD pipeline is triggered when we push the code to the main branch. We have used the following tools in the CI/CD pipeline: terraform, bandit, docker, trivy, and kubectl. We have deployed the flask app and redis on the EKS cluster. We have created two services within in the same namespace - redis service with type ClusterIP and flask service with type NodePort. The flask app is available outside the cluster using the NodePort service on the port 30080. The flask app connects with redis using the redis service name on port 6379.

### References

- https://www.terraform.io/
- https://www.docker.com/
- https://kubernetes.io/
- https://flask.palletsprojects.com/en/2.0.x/
- https://redis.io/
- https://gitlab.com/
- https://docs.gitlab.com/ee/ci/
- https://docs.gitlab.com/ee/user/project/variables/
- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
- https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html
- https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html


