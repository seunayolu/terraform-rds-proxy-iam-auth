# AWS RDS End-to-End IAM Authentication via RDS Proxy

[![Node.js](https://img.shields.io/badge/Node.js-20.x-339933?logo=node.js&logoColor=white)](https://nodejs.org/docs/latest-v23.x/api/)
[![AWS Cloud](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/)
[![RDS MySQL Guide](https://img.shields.io/badge/AWS_RDS-MySQL-527FFF?logo=amazon-rds&logoColor=white)](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html/)
[![RDS Proxy](https://img.shields.io/badge/AWS_EC2-Compute-FF9900?logo=amazon-rds&logoColor=white)](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBProxy.html/)
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/_/node/)
[![AWS IAM Auth](https://img.shields.io/badge/AWS_IAM-Authentication-FF9900?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html/)
[![SSM Parameter](https://img.shields.io/badge/AWS_Systems_Manager-Configuration-FF9900?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html/)
[![Terraform](https://img.shields.io/badge/Terraform-1.12.2-623CE4?logo=terraform&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy/)

This repository contains a **Terraform** project that implements a fully automated, **Zero-Secret** (IAM-based) architecture for Amazon RDS. It covers the entire lifecycle from VPC networking and High-Availability NAT Gateways to the automated bootstrapping of database users via AWS Lambda.

## 🏗️ Architecture Overview

The project follows a "Least Privilege" security model where no long-lived database credentials are stored within the application environment.

* **Compute:** EC2 Instance running a Node.js application in a private subnet.
* **Database:** Amazon RDS (MySQL) with IAM Database Authentication enabled.
* **Proxy:** Amazon RDS Proxy acting as the IAM-to-DB bridge.
* **Authentication:** * **App to Proxy:** Native IAM Authentication using `rds-db:connect`.
* **Proxy to DB:** Native IAM Authentication + Secrets Manager (Master Secret) for backend pooling.


* **Automation:** AWS Lambda function to bootstrap the `AWSAuthenticationPlugin` users in MySQL upon deployment.

---

## 🚀 Key Features

* **Regional High Availability:** Multi-AZ VPC deployment with one NAT Gateway per Availability Zone for fault tolerance.
* **Secretless App Environment:** Applications use the AWS SDK to generate short-lived IAM tokens; no DB passwords are saved in SSM or Environment Variables.
* **Automated Bootstrapping:** Includes a Python-based Lambda function that automatically creates the required MySQL users (`IDENTIFIED WITH AWSAuthenticationPlugin`) during the initial Terraform apply.
* **Dynamic IAM Policies:** Automatically extracts the **Proxy Resource ID** (`prx-xxx`) and **DBI Resource ID** (`db-xxx`) from ARNs to build precise `rds-db:connect` policies.

---

## 🔍 The "Hidden" API Challenge

A core highlight of this project is the resolution of a documented contradiction in the AWS RDS API.

> **The Issue:** While the AWS Console and API documentation mark the `SecretArn` as optional when using `IAM_AUTH`, the API internally rejects the request with an `InvalidParameterValue: Missing SecretArn` error if you attempt to customize the `auth` block (e.g., setting `iam_auth = "REQUIRED"` or forcing `MYSQL_NATIVE_PASSWORD`).

**The Solution:** This project demonstrates how to satisfy the AWS API validator by linking the RDS Master User Secret (managed by RDS) while still enforcing a 100% IAM-based flow for the application.

---

## 🛠️ Tech Stack

* **Infrastructure:** Terraform
* **Provider:** AWS
* **Database:** MySQL 8.4.7
* **Compute:** Ubuntu 24.04 (Noble Numbat)
* **Containerization:** Docker (Alpine-based Node 23)
* **Automation:** Python 3.12 (Lambda)

## 📝 Lessons Learned

* **The 80/20 Rule:** 80% of DevOps is navigating the nuances of API behavior; 20% is writing the actual code.
* **Provider Quirk:** The `aws_db_proxy` resource ID in Terraform returns the *name*, but IAM policies require the *Resource ID*. This project uses `split()` and `element()` functions to dynamically extract the correct ID from the ARN.

## ALB Logging to S3
- https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html
- https://docs.aws.amazon.com/elasticloadbalancing/latest/application/describe-ssl-policies.html
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-creating.html
- https://github.com/hashicorp/terraform-provider-aws/issues/46461
- https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_ModifyLoadBalancerAttributes.html

### SSM Start Session
```bash
aws ssm start-session \
    --target i-0123456789abcdef \
    --document-name AWS-StartInteractiveCommand \
    --parameters 'command=["bash -l"]'
```

### CREATE DB User with AWSAuthPlugin
```bash
-- Create a database user that uses AWS IAM authentication and mandates SSL
CREATE USER 'app_user'@'%' 
IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';

-- Require SSL for this specific user
ALTER USER 'app_user'@'%' REQUIRE SSL;

-- Grant necessary privileges
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON rds_app_db.* TO 'app_user'@'%';

-- Verify the user setup (now checking for SSL requirement)
SELECT User, Host, plugin, ssl_type 
FROM mysql.user 
WHERE User = 'app_user';
```
### Generate RDS IAM Auth Token for Proxy Connection
```bash
aws rds generate-db-auth-token \
    --hostname <proxy-endpoint> \
    --port 3306 \
    --region <rds_proxy_region> \
    --username <rds_db_username_with_auth_plugin>
```
### SSM Start Port Forwarding Session to Remote Host
```bash
aws ssm start-session \
    --target instance-id \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters '{"host":["mydb.example.us-east-2.rds.amazonaws.com"],"portNumber":["3306"], "localPortNumber":["3306"]}'
```

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 442042522885.dkr.ecr.us-east-1.amazonaws.com
```



