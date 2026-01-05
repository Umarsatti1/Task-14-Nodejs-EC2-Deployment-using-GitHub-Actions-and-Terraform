# Deploying a Node.js Application on AWS EC2 Using Terraform and GitHub Actions

---

## Project Overview
This project demonstrates a complete **end-to-end CI/CD pipeline** for deploying a Node.js application on AWS using **Terraform** and **GitHub Actions**.  
All infrastructure is provisioned as code, and application deployments are fully automated with **zero-downtime rolling updates** using Auto Scaling Groups and an Application Load Balancer.

A **GitHub self-hosted runner** is deployed on a private EC2 instance without a public IP. Secure access and automation are achieved using **AWS Systems Manager (SSM)** and **Parameter Store**, eliminating the need for SSH keys or hardcoded secrets.

---

## Architecture Overview

<p align="center">
  <img src="./diagram/Architecture Diagram.png" alt="Architecture Diagram" width="900">
</p>

The architecture follows AWS best practices for security, scalability, and high availability:

- Custom VPC with public and private subnets across multiple AZs
- Application EC2 instances deployed in **private subnets**
- Application Load Balancer handling inbound HTTP traffic
- Auto Scaling Group for application instances
- GitHub self-hosted runner EC2 in a private subnet
- Centralized logging using Amazon CloudWatch
- Secure access using IAM roles and AWS SSM

---

## Project Structure
The repository is organized to clearly separate application code, infrastructure, and CI/CD configuration.

### Application Files
- **app.js** – Express-based Node.js application entry point
- **package.json** – Application dependencies and runtime configuration
- **public/index.html** – Static UI used to verify deployment success

### Terraform Infrastructure
Terraform code is written using a **modular design** to ensure clarity and reusability.

#### Root Terraform Files
- **terraform.tf** – Provider versions and remote backend configuration
- **main.tf** – Central orchestration of all modules
- **variables.tf / terraform.tfvars** – Input variables and environment values
- **outputs.tf** – Exposes ALB DNS and runner EC2 private IP

#### Terraform Modules
- **VPC Module** – Networking, subnets, routing, NAT, and security groups
- **IAM Module** – EC2 roles, instance profiles, and policies
- **EC2 Module** – Application EC2 (ASG + Launch Template) and GitHub runner EC2

---

## EC2 Bootstrapping
### Application EC2
Application instances are bootstrapped using a user data script that:
- Installs Node.js, npm, PM2, and Nginx
- Configures Nginx as a reverse proxy
- Sets up CloudWatch logging
- Starts the Node.js app using PM2

### GitHub Runner EC2
The runner EC2 bootstrap script:
- Installs AWS CLI, Node.js, and npm
- Retrieves the GitHub runner token from SSM Parameter Store
- Registers and starts the GitHub Actions runner
- Configures CloudWatch logging for observability

---

## CI/CD Pipeline (GitHub Actions)
The GitHub Actions workflow is triggered manually using `workflow_dispatch`.

Pipeline responsibilities:
- Checkout application code
- Install dependencies
- Validate application changes
- Trigger Auto Scaling Group rolling instance refresh

This enables **zero-downtime deployments** by gradually replacing instances while maintaining application availability.

---

## Deployment Verification
Successful pipeline execution confirms:
- GitHub runner is active and registered
- All workflow steps complete without errors
- ASG rolling refresh is triggered
- Old instances are drained gracefully
- New instances transition from Unhealthy → Healthy

The updated application becomes available automatically through the ALB.

---

## Observability with CloudWatch
CloudWatch is used for centralized logging and visibility.

### Log Groups
- **nodejs-app** – Application logs (PM2 + Nginx)
- **github-runner** – Runner logs and cloud-init output

Logs are dynamically created per instance, ensuring visibility even during scaling events.

---

## Cleanup
All resources are destroyed using:
```bash
terraform destroy -auto-approve
```
This ensures no AWS resources remain running and prevents unnecessary costs.

---

## Troubleshooting
### Issue 1: Invalid BASE64 User Data
**Cause:** Launch Templates require BASE64-encoded user data  
**Fix:** Wrapped user data with `base64encode()`

### Issue 2: 504 Gateway Timeout
**Cause:** Broken application user data script  
**Fix:** Corrected script syntax and dependency installation

### Issue 3: Runner Not Active
**Cause:** Incorrect directory ownership  
**Fix:** Updated ownership using:
```bash
sudo chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
```

### Issue 4: npm Command Not Found
**Cause:** Node.js not installed on runner  
**Fix:** Installed Node.js and npm via user data

---

## Key Takeaways
- Infrastructure fully managed using Terraform
- Secure CI/CD without public IPs or SSH
- Zero-downtime deployments using ASG rolling refresh
- Centralized logging and observability

---