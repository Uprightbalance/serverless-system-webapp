# Production-Style Serverless Web Application on AWS using Terraform and GitHub Actions

A production-style **serverless web application** deployed on AWS using **Terraform** and automated end-to-end with **GitHub Actions**.

This project demonstrates how to provision, secure, and deploy a **modern pay-per-use cloud application** with **minimal manual steps**, modular Infrastructure as Code, and environment-aware CI/CD workflows.

---

## Overview

This project simulates how a small-to-medium production web application can be deployed using a **serverless-first architecture** on AWS.

It was designed to achieve the following goals:

- **Low operational overhead**
- **Cost efficiency for low-to-moderate traffic**
- **Environment isolation**
- **Security best practices**
- **Repeatable infrastructure provisioning**
- **Hands-off frontend deployment**
- **Backend API hosting without managing servers**

The application is composed of:

- a **Vite React frontend**
- **Amazon DynamoDB** provisioned as the target persistence layer for the serverless architecture
- **Amazon API Gateway** as the HTTP entry point
- **Amazon DynamoDB** as the persistence layer
- **Terraform** for infrastructure provisioning
- **GitHub Actions** for CI/CD automation

---

## Why This Architecture

This stack was intentionally chosen to reflect a **practical real-world deployment pattern** for applications that need to be:

- easy to deploy
- inexpensive to run when idle
- scalable on demand
- simple to maintain without server management

### Why serverless?

A serverless architecture removes the need to manage:

- EC2 instances
- patching and OS maintenance
- capacity planning for idle workloads
- always-on infrastructure costs

This makes it a strong fit for:

- portfolio-grade production projects
- startup MVPs
- business websites with transactional forms
- event-driven APIs
- applications with variable traffic

---

# Architecture

## High-Level Flow

```text
User
  ↓
CloudFront
  ↓
S3 (Frontend Assets)

Frontend (Vite React)
  ↓
API Gateway
  ↓
AWS Lambda
  ↓
DynamoDB
```

---

## Component Breakdown

### Frontend
* Vite React
* Static assets hosted in Amazon S3
* Globally distributed via Amazon CloudFront

### Backend
* Python API
* Packaged and deployed to AWS Lambda
* Invoked through Amazon API Gateway (HTTP API)

### Database
* Amazon DynamoDB
* Configured with PAY_PER_REQUEST billing

### Infrastructure as Code
* Terraform
* Modularized by responsibility and environment

### CI/CD
* GitHub Actions
* Automates infrastructure deployment and frontend publishing

---

# Repository Structure

```text
serverless-project/
├── mrbaffo-backend/                  # Python backend source code
├── mrbaffo-frontend/                 # Vite React frontend source code
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   ├── modules/
│   │   ├── apigateway/
│   │   ├── dynamodb/
│   │   ├── frontend_hosting/
│   │   ├── iam/
│   │   └── lambda/
│   ├── main.tf
│   ├── providers.tf
│   └── variables.tf
└── .github/workflows/
```

# Core Capabilities

* Fully serverless AWS architecture
* Modular Terraform infrastructure
* Multi-environment deployment model
* Automated frontend build and publishing
* CloudFront-backed secure static hosting
* API Gateway to Lambda integration
* DynamoDB persistence layer
* CI/CD deployment through GitHub Actions
* Dynamic environment variable injection
* Pay-per-use infrastructure design

# AWS Services Used

* Amazon S3
* Amazon CloudFront
* AWS Lambda
* Amazon API Gateway
* Amazon DynamoDB
* AWS IAM
* Amazon CloudWatch Logs

# Design Decisions and Rationale

## 1) Frontend hosted on S3 + CloudFront

Why this was chosen

The frontend is a static Vite React build, which makes S3 + CloudFront a natural fit.

### Benefits

* extremely low hosting cost
* no web server to manage
* fast global delivery
* simple cache invalidation
* integrates well with CI/CD

### Tradeoff

* frontend is static only
* no server-side rendering
* cache invalidation must be handled after deployment

## Why it was acceptable

This application does not require SSR or per-request rendering, so static hosting is operationally simpler and cheaper.

## 2) Backend deployed on AWS Lambda

Why this was chosen

The backend is API-driven and request-based, making Lambda a strong fit.

### Benefits

* no server management
* scales automatically
* cost-effective for low or bursty traffic
* integrates cleanly with API Gateway

### Tradeoffs

* cold starts
* runtime packaging considerations
* not ideal for long-running or connection-heavy workloads

## Why it was acceptable

This application handles lightweight transactional requests such as:

* contact form submissions
* pickup requests
* metadata retrieval

> These are well-suited to Lambda execution.

## 3) API Gateway used as the HTTP entry point

### Why this was chosen

API Gateway provides a secure and managed interface between the frontend and Lambda backend.

### Benefits

* no reverse proxy required
* native Lambda integration
* route management
* request handling and deployment stages
* easier serverless API exposure

### Tradeoffs

* request pricing per invocation
* slightly more configuration complexity than a traditional app server

## Why it was acceptable

The application benefits more from operational simplicity than from minimizing per-request control-plane complexity.

## 4) DynamoDB used instead of PostgreSQL

This was one of the most important architecture decisions in the project.

### Why DynamoDB Was Chosen Over PostgreSQL

The backend was originally structured in a way that suggested PostgreSQL / SQLAlchemy-style persistence, but the infrastructure was ultimately aligned to DynamoDB to better fit the serverless operating model.

#### Why PostgreSQL was not the best fit here

A traditional PostgreSQL database introduces additional infrastructure and operational concerns in a serverless deployment:

* requires a database instance or cluster
* introduces baseline cost even when idle
* needs connection management
* less naturally aligned with bursty Lambda workloads
* may require connection pooling or RDS Proxy
* more moving parts for a relatively simple application

> For a lightweight form-based application, PostgreSQL would have been more infrastructure than necessary.

## Why DynamoDB was a better fit

DynamoDB was chosen because this application primarily needs to store simple request records, such as:

* contact submissions
* pickup requests

#### These workloads are:

* straightforward
* write-heavy but not relational
* not dependent on complex joins
* well-suited to document/key-value storage

### DynamoDB advantages in this use case

* fully managed
* no connection pool issues with Lambda
* scales automatically
* no idle compute cost
* native pay-per-request pricing
* easier operational model for serverless apps

## Tradeoffs: DynamoDB vs PostgreSQL

### DynamoDB Advantages
* better fit for Lambda
* no DB server management
* scales automatically
* low cost for low traffic
* simpler deployment architecture

### DynamoDB Tradeoffs
* no joins
* no relational constraints
* query patterns must be designed intentionally
* schema flexibility can become a liability if not structured well

## PostgreSQL Advantages

* strong relational modeling
* SQL support
* easier ad hoc querying
* better for reporting and multi-table relationships

### PostgreSQL Tradeoffs

* more infrastructure overhead
* higher baseline cost
* connection handling complexity in serverless environments
* less cost-efficient for very light traffic

---

# Decision Summary

For this application’s workload and project goals, DynamoDB was the more appropriate engineering choice because it better aligned with:

* serverless principles
* pay-per-use cost control
* operational simplicity
* deployment automation

If this application later evolves into something requiring:

* relational reporting
* advanced filtering
* joins
* transactional workflows across entities

> then migrating to Amazon RDS PostgreSQL would become more justified.

---

# Environment Strategy

The infrastructure is separated into isolated deployment environments:

* dev
* staging
* prod

Each environment contains its own configuration and outputs.

Example:

terraform/environments/staging/

---

# Why this matters

This allows:

* safer testing before production
* resource isolation
* easier debugging
* environment-specific values
* cleaner CI/CD workflows

It also reduces the chance of:

* accidental production changes
* resource name collisions
* shared-state deployment mistakes

# Terraform Design

The Terraform codebase is intentionally modularized for maintainability and reuse.

## Modules
#### iam

Responsible for:

* Lambda execution role
* CloudWatch logging permissions
* DynamoDB access policy

#### lambda

Responsible for:

* Lambda function deployment
* runtime configuration
* environment variable injection

#### apigateway

Responsible for:

* HTTP API creation
* Lambda integration
* route configuration
* invoke permissions

#### dynamodb

Responsible for:

* DynamoDB table provisioning
* pay-per-request billing mode

#### frontend_hosting

Responsible for:

* S3 bucket creation
* CloudFront distribution
* secure frontend delivery

### Why modular Terraform was used

This makes the infrastructure:

* easier to reason about
* easier to extend
* easier to test across environments
* more reusable in future projects

> It also better reflects how production IaC is typically organized.

# Security Considerations

This project was designed with practical security controls in mind.

### Security measures applied

* Frontend S3 bucket is not publicly exposed
* Static content is delivered through CloudFront
* Backend execution uses dedicated IAM roles
* Infrastructure is separated by environment
* Frontend API endpoint is injected dynamically, not hardcoded
* Sensitive values can be stored in GitHub Secrets
* Serverless architecture reduces exposed infrastructure surface area

### Security philosophy

This project follows a secure-by-default mindset while keeping implementation complexity appropriate for the application’s size.

> It does not attempt to over-engineer security controls prematurely, but it does establish good baseline patterns.

---

# Cost Considerations

A major design goal of this project was to stay cost-conscious while still using production-style architecture.

## Why this stack is cost-efficient

### S3
* low-cost object storage for static assets

### CloudFront
* pay for delivery and requests
* inexpensive for small-to-moderate traffic

### Lambda
* billed only on execution time and requests
* ideal for low idle workloads

### API Gateway
* pay-per-request model
* avoids running dedicated backend servers

### DynamoDB
* PAY_PER_REQUEST billing
* avoids paying for unused provisioned capacity

## Cost advantages of this architecture

This stack is especially cost-effective when:

* traffic is low to moderate
* requests are bursty
* application is not constantly busy

That makes it excellent for:

* startups
* MVPs
* small businesses
* portfolio and demo applications
* event-driven services

## Cost tradeoffs

At very high sustained traffic, some serverless services can become more expensive than always-on infrastructure.

For example:

* Lambda can become costlier than containers or EC2 under heavy sustained load
* API Gateway pricing can accumulate at high request volumes
* CloudFront invalidations and bandwidth should still be monitored

## Practical takeaway

This architecture is highly cost-efficient early, but should still be periodically re-evaluated as scale grows.

---

# CI/CD Workflow

This project uses GitHub Actions to automate both infrastructure deployment and frontend publishing.

## Deployment pipeline includes

1. Checkout repository
2. Configure AWS credentials
3. Run Terraform:
   * terraform init
   * terraform apply
4. Extract Terraform outputs:
   * API URL
   * S3 bucket name
   * CloudFront distribution ID
5. Generate frontend environment file
6. Build Vite React frontend
7. Upload built frontend to S3
8. Invalidate CloudFront cache

---

# Deployment Flow

```text
Push to main
   ↓
GitHub Actions workflow starts
   ↓
Terraform provisions or updates AWS resources
   ↓
Terraform outputs are extracted
   ↓
Frontend .env.production is generated dynamically
   ↓
Vite frontend is built
   ↓
dist/ is uploaded to S3
   ↓
CloudFront cache is invalidated
```

# CORS Strategy

The backend is configured to allow requests from the deployed frontend origin.

Example deployed value

```env
CORS_ORIGINS=https://your-cloudfront-domain
```

Example local development value

```env
CORS_ORIGINS=http://localhost:5173
```

## Why this matters

This ensures:

* browser requests succeed correctly
* frontend and backend remain environment-aware
* CORS remains controlled instead of fully open in deployed environments

# Useful Terraform Outputs

After deployment, Terraform exposes key infrastructure values.

Examples include:

* frontend_url
* api_gateway_url
* cloudfront_distribution_id
* s3_bucket_name
* lambda_function_name
* dynamodb_table_name

## Show all outputs

```bash
terraform output
```

## Fetch specific values

```bash
terraform output -raw frontend_url
terraform output -raw api_gateway_url
```

# Local Terraform Usage

## Deploy staging

```bash
cd terraform/environments/staging

terraform init
terraform plan
terraform apply -auto-approve
```

# Setup Notes

## Prerequisites

Before deployment, ensure you have:

* AWS account
* Terraform installed
* AWS CLI configured (for local workflows)
* GitHub repository
* GitHub Actions secrets configured:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY

## Frontend deployment expectation

The frontend is expected to build into:

mrbaffo-frontend/dist/

> This output is uploaded to the provisioned S3 bucket during CI/CD.

## Backend deployment expectation

The backend is expected to be packaged for Lambda deployment and configured with the required environment variables.

Typical environment variables include:

```bash
APP_NAME=MR BAFFO API
ENVIRONMENT=staging
DYNAMODB_TABLE_NAME=your-serverless-app-table
CORS_ORIGINS=https://your-cloudfront-domain
```

---

# Real-World Engineering Challenges Addressed

This project involved troubleshooting and resolving issues that commonly appear in real infrastructure work, including:

* Terraform module input mismatches
* Lambda packaging/runtime issues
* API Gateway invoke permission problems
* CloudFront / S3 access denied issues
* missing Terraform outputs

> These were real issues — with patience and rollback on my part i was able to resolve all in good time.

# Skills Demonstrated

This project demonstrates hands-on ability in:

- Terraform
- AWS serverless architecture
- Terraform remote state with S3
- GitHub Actions CI/CD
- modular Infrastructure as Code
- secure cloud deployment patterns
- environment-aware infrastructure design
- frontend/backend deployment integration
- operational troubleshooting and debugging
- cost-conscious architecture decisions
- technical tradeoff evaluation

---

# Key Takeaway

This project was designed not just to “deploy an app,” but to demonstrate how to think through:

* infrastructure design
* security
* automation
* cost
* environment separation
* backend tradeoffs
* operational simplicity

> It reflects a practical production-style serverless deployment workflow using AWS, Terraform, and GitHub Actions.
