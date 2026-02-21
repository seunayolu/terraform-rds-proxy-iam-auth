# AWS RDS Proxy End-to-End IAM Authentication (Zero-Secret Architecture)

[![Node.js](https://img.shields.io/badge/Node.js-20.x-339933?logo=node.js&logoColor=white)](https://nodejs.org/docs/latest-v23.x/api/)
[![AWS Cloud](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/)
[![RDS MySQL Guide](https://img.shields.io/badge/AWS_RDS-MySQL-527FFF?logo=amazon-rds&logoColor=white)](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html/)
[![RDS Proxy](https://img.shields.io/badge/AWS_EC2-Compute-FF9900?logo=amazon-rds&logoColor=white)](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBProxy.html/)
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/_/node/)
[![AWS IAM Auth](https://img.shields.io/badge/AWS_IAM-Authentication-FF9900?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html/)
[![SSM Parameter](https://img.shields.io/badge/AWS_Systems_Manager-Configuration-FF9900?logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html/)
[![Terraform](https://img.shields.io/badge/Terraform-1.12.2-623CE4?logo=terraform&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy/)

## Overview

This project implements a fully automated, end-to-end IAM authentication
flow between:

-   A Node.js application\
-   Amazon RDS Proxy\
-   Amazon RDS (MySQL)

The architecture eliminates long-lived database credentials and enforces
short-lived IAM-based authentication from the application layer to the
database.

All infrastructure is provisioned using a modular Terraform
architecture, and CI/CD is implemented using GitHub Actions with OIDC
federation.

## 🏗 Architecture Modules

    modules/
     ├── vpc/
     ├── iam/
     ├── ec2/
     ├── rds/
     ├── security_group/
     ├── alb/
     ├── s3/
     └── ecr/

## Authentication Flow

### 1️⃣ App → Proxy

Application generates short-lived IAM token:

``` bash
aws rds generate-db-auth-token     --hostname <proxy-endpoint>     --port 3306     --region us-east-1     --username node_app
```

### 2️⃣ Proxy → RDS

-   Uses RDS-managed master secret (Secrets Manager)
-   Backend pooling handled by RDS Proxy
-   MySQL users configured with AWSAuthenticationPlugin

## Database Bootstrap Strategy

A secure shell-based bootstrap script:

1.  Reads generated `rds.conf`
2.  Retrieves master credentials from Secrets Manager
3.  Creates IAM-enabled admin user
4.  Switches to IAM authentication
5.  Creates application users
6.  Enforces SSL
7.  Grants least-privilege permissions

Example SQL:

``` sql
CREATE USER 'node_app'@'%'
IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';

ALTER USER 'node_app'@'%' REQUIRE SSL;

GRANT SELECT, INSERT, UPDATE, DELETE ON node_db.* TO 'node_app'@'%';
```

## CI/CD Pipeline (GitHub Actions)

### Pull Request

-   Terraform validate
-   TFLint
-   Checkov scan
-   Terraform plan
-   Docker build
-   Trivy scan

### Push to Main

-   Terraform apply
-   Extract outputs
-   Upload rds.conf artifact
-   Build & push image to ECR
-   OIDC-based AWS authentication

### Manual Trigger

-   Terraform destroy

## Security Highlights

-   OIDC federation (no static AWS keys)
-   No DB passwords stored in environment variables
-   SSL enforced at MySQL level
-   Least privilege IAM policies
-   Terraform static analysis
-   Container image scanning

## The "Hidden" API Challenge

A core highlight of this project is the resolution of a documented contradiction in the AWS RDS API.

> **The Issue:** While the AWS Console and API documentation mark the `SecretArn` as optional when using `IAM_AUTH`, the API internally rejects the request with an `InvalidParameterValue: Missing SecretArn` error if you attempt to customize the `auth` block (e.g., setting `iam_auth = "REQUIRED"` or forcing `MYSQL_NATIVE_PASSWORD`).

**The Solution:** This project demonstrates how to satisfy the AWS API validator by linking the RDS Master User Secret (managed by RDS) while still enforcing a 100% IAM-based flow for the application.

# Bash Conditional Flags Reference

  -----------------------------------------------------------------------
  Flag          Meaning              Common Use Case
  ------------- -------------------- ------------------------------------
  `-z`          Zero length: True if `[[ -z "$DB_PASSWORD" ]]` (Check if
                the string is empty  a secret is missing)

  `-n`          Non-zero length:     `[[ -n "$GIT_TAG" ]]` (Check if a
                True if string is    version exists)
                NOT empty            

  `-e`          Exists: True if file `[[ -e "tfplan" ]]` (Check if plan
                or directory exists  file was created)

  `-f`          File: Exists and is  `[[ -f "rds.conf" ]]` (Verify config
                regular file         file exists)

  `-d`          Directory: Exists    `[[ -d "Terraform/" ]]` (Verify
                and is directory     directory structure)

  `-x`          Executable: File     `[[ -x "./deploy.sh" ]]` (Check
                exists and           script permissions)
                executable           
  -----------------------------------------------------------------------

# Bash Safety Mode (Error Handling in CI/CD)

In production-grade scripts, always enable safety mode:

``` bash
set -euxo pipefail
```

## Explanation of Flags

### `set -e` (errexit)

Exit immediately if a command fails. Prevents execution from continuing
after failures like `terraform init`.

### `set -u` (nounset)

Treat unset variables as errors. Prevents dangerous expansions like:

    rm -rf /$UNDEFINED_VAR

### `set -o pipefail`

If any command in a pipeline fails, the entire pipeline fails. Ensures
hidden failures don't pass silently.

### `set -x` (xtrace)

Prints each command before execution. Extremely useful for debugging
GitHub Actions logs.

## Useful links and commands

### ALB Logging to S3
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
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account_id>.dkr.ecr.us-east-1.amazonaws.com
```

## 🏁 Final Result

-   End-to-end IAM authentication
-   Zero long-lived secrets
-   Fully automated provisioning
-   Secure DevSecOps pipeline
-   Modular Terraform architecture

