# Threat Composer on AWS

I built this as a production-style deployment of Threat Composer on AWS. The application is containerised with Docker and deployed to Amazon ECS Fargate behind an Application Load Balancer. I manage the infrastructure using Terraform modules and automate deployments through GitHub Actions.

I ship releases using ECS rolling deployments and store container images in Amazon ECR. I terminate TLS on the ALB with ACM and route traffic through Route 53 using a custom domain. Infrastructure is provisioned through reusable Terraform modules covering networking, load balancing, ECS, IAM, ACM, and DNS management.

For CI/CD, I use GitHub Actions with OpenID Connect (OIDC) authentication. Instead of storing long-lived AWS access keys as GitHub secrets, GitHub exchanges an OIDC token for temporary AWS credentials at runtime. This reduces the risk associated with credential leakage and follows AWS security best practices by using short-lived credentials that automatically expire after the workflow completes.

I also store Terraform state remotely in Amazon S3 with native state locking enabled. This provides a central source of truth for infrastructure management and prevents concurrent state modifications during Terraform operations.

# Architecture

When someone opens my app URL , Route 53 points the domain to my Application Load Balancer. The load balancer handles HTTPS using an ACM certificate and redirects HTTP traffic to HTTPS.

From the load balancer, traffic is forwarded to a target group connected to my ECS Fargate service. ECS runs the Threat Composer container using an image stored in Amazon ECR. The application listens on port 3000, and the ECS service keeps the desired task count running.

The ECS tasks write logs to CloudWatch Logs through the ECS task execution role. Security groups are used to control access between the load balancer and the ECS tasks, so application traffic only reaches the container through the ALB path.

Terraform manages the infrastructure using separate modules for VPC, ALB, ECS, IAM, ACM, and Route 53. Terraform state is stored remotely in Amazon S3 with native state locking enabled to provide a central source of truth and prevent concurrent infrastructure changes.

# High-level architecture


![alt text](image-1.png)

#  OIDC Trust Policy
I use GitHub OIDC to allow GitHub Actions to assume an AWS IAM role using short-lived credentials. The trust policy restricts access to my repository, removing the need for long-lived AWS access keys.

![alt text](image-2.png)

# Security and Guardrails

I configured the Application Load Balancer with an ACM certificate and redirect HTTP traffic to HTTPS, ensuring all communication with the application is encrypted in transit.

Access to the ECS tasks is controlled through security groups. The ECS security group only allows inbound traffic from the Application Load Balancer security group on the application port, preventing direct access to the containers from the internet.

For authentication and automation, I use GitHub OpenID Connect (OIDC) instead of long-lived AWS access keys. The IAM trust policy restricts role assumption to workflows running from my GitHub repository, allowing GitHub Actions to obtain temporary AWS credentials at runtime while reducing the risk associated with storing permanent credentials.

The application uses a dedicated ECS task execution role that allows tasks to pull container images from Amazon ECR and send logs to CloudWatch Logs. Infrastructure access is separated from application permissions by using different IAM roles for ECS and GitHub Actions.

Terraform state is stored remotely in Amazon S3 with native state locking enabled, providing a central source of truth and preventing concurrent infrastructure modifications.


