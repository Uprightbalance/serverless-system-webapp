# Production-Style Serverless Web Application on AWS using Terraform and GitHub Actions

A production-style **serverless web application** deployed on AWS using **Terraform** and automated with **GitHub Actions**.

This project demonstrates how to provision and deploy a **secure, scalable, low-maintenance, pay-per-use application** with **minimal manual steps** using Infrastructure as Code (IaC).

---

## 📌 Project Overview

This project was built to simulate a real-world cloud deployment workflow for a modern web application using AWS serverless services.

The application is split into:

- a **Vite React frontend**
- a **Python backend running on AWS Lambda**
- an API layer via **Amazon API Gateway**
- a NoSQL data layer using **Amazon DynamoDB**
- automated deployment with **GitHub Actions**
- infrastructure provisioning with **Terraform**

The goal was to build an environment-aware deployment system with:

- **dev**
- **staging**
- **prod**

while applying **security best practices**, reducing operational overhead, and keeping infrastructure modular and reusable.

---

## 🚀 Architecture

### Frontend
- **Vite React**
- Hosted on **Amazon S3**
- Delivered globally via **Amazon CloudFront**

### Backend
- **Python application**
- Runs on **AWS Lambda**
- Triggered through **Amazon API Gateway (HTTP API)**

### Database
- **Amazon DynamoDB**
- Configured with **PAY_PER_REQUEST** billing for cost efficiency

### Infrastructure as Code
- **Terraform**

### CI/CD
- **GitHub Actions**

---

## 🏗️ High-Level Architecture Diagram

```text
User
  ↓
CloudFront
  ↓
S3 (Frontend)

Frontend (Vite React)
  ↓
API Gateway
  ↓
AWS Lambda
  ↓
DynamoDB
```

---

## 📂 Repository Structure

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
└── .github/workflows/        # Deployment automation
```

---

## ⚙️ Core Features

- ✅ Fully serverless AWS architecture
- ✅ Modular Terraform infrastructure
- ✅ Multi-environment deployment structure
- ✅ Frontend auto-build and deployment
- ✅ CloudFront distribution for global content delivery
- ✅ API Gateway to Lambda backend integration
- ✅ DynamoDB backend persistence
- ✅ CI/CD pipeline using GitHub Actions
- ✅ Secure-by-default cloud deployment approach
- ✅ Minimal manual deployment steps

---

## 🛠 AWS Services Used

- **Amazon S3**
- **Amazon CloudFront**
- **AWS Lambda**
- **Amazon API Gateway**
- **Amazon DynamoDB**
- **AWS IAM**
- **Amazon CloudWatch Logs**

---

## 🔐 Security Best Practices Applied

This project was designed with practical security considerations in mind:

- S3 frontend bucket is **not publicly exposed**
- Frontend is securely delivered through **CloudFront**
- Lambda execution uses **dedicated IAM roles and policies**
- Infrastructure is separated by environment (**dev / staging / prod**)
- API and frontend values are dynamically injected rather than hardcoded
- Sensitive values can be managed through **GitHub Secrets**
- Serverless architecture reduces server attack surface and patching overhead

---

## 🌍 Environment Strategy

The project is organized into isolated deployment environments:

- **dev**
- **staging**
- **prod**

Each environment contains its own:

- `main.tf`
- `variables.tf`
- `terraform.tfvars`
- `outputs.tf`

Example:

```text
terraform/environments/staging/
```

This makes it easier to:

- test safely
- avoid resource collisions
- separate deployment workflows
- prepare for real-world release patterns

---

## 🧱 Terraform Module Design

The infrastructure is broken into reusable modules for maintainability and clarity.

### `iam`
Responsible for:
- Lambda execution role
- CloudWatch logging permissions
- DynamoDB access policy

### `lambda`
Responsible for:
- Lambda function deployment
- Runtime configuration
- Environment variables

### `apigateway`
Responsible for:
- HTTP API creation
- Lambda integration
- Route configuration
- Invoke permissions

### `dynamodb`
Responsible for:
- DynamoDB table provisioning
- Pay-per-request billing model

### `frontend_hosting`
Responsible for:
- S3 bucket creation
- CloudFront distribution
- Secure frontend hosting

---

## 🚀 CI/CD Pipeline

This project uses **GitHub Actions** to automate deployment.

### Deployment workflow includes:

1. Checkout repository
2. Configure AWS credentials
3. Run Terraform:
   - `terraform init`
   - `terraform apply`
4. Extract Terraform outputs:
   - API URL
   - S3 bucket name
   - CloudFront distribution ID
5. Inject frontend environment variables
6. Build Vite React frontend
7. Upload built frontend to S3
8. Invalidate CloudFront cache

---

## 🔄 Deployment Flow

```text
Push to main
   ↓
GitHub Actions workflow runs
   ↓
Terraform provisions/updates AWS resources
   ↓
Terraform outputs are extracted
   ↓
Frontend .env is generated dynamically
   ↓
Frontend is built using Vite
   ↓
dist/ is uploaded to S3
   ↓
CloudFront cache is invalidated
```

---

## 🧾 Useful Terraform Outputs

After deployment, Terraform provides useful infrastructure values such as:

- `frontend_url`
- `api_gateway_url`
- `cloudfront_distribution_id`
- `s3_bucket_name`
- `lambda_function_name`
- `dynamodb_table_name`

Example:

```bash
terraform output
```

Or fetch specific values:

```bash
terraform output -raw frontend_url
terraform output -raw api_gateway_url
```

---

## 🧪 Example Local Terraform Deployment

### Deploy staging environment

```bash
cd terraform/environments/staging

terraform init
terraform plan
terraform apply -auto-approve
```

### Destroy environment

```bash
terraform destroy -auto-approve
```

---

## 🌐 Frontend Environment Variable Injection

The frontend consumes the backend API URL using:

```env
VITE_API_BASE_URL=<api_gateway_url>
```

This value is injected automatically during deployment, avoiding hardcoded backend endpoints.

Example frontend usage:

```js
const rawBaseUrl = import.meta.env.VITE_API_BASE_URL;
```

---

## 🔗 CORS Strategy

The backend is configured to allow requests from the deployed frontend origin.

### Example deployed value

```env
CORS_ORIGINS=https://your-cloudfront-domain
```

### Example local development value

```env
CORS_ORIGINS=http://localhost:5173
```

This ensures that frontend-to-backend communication works correctly both locally and after deployment.

---

## 🐛 Real-World Challenges Solved During Build

This project involved troubleshooting and resolving common real-world cloud deployment issues such as:

- Terraform module input mismatches
- Resource naming collisions across environments
- S3 bucket uniqueness constraints
- IAM resource duplication
- Lambda packaging/runtime failures
- API Gateway invoke permission issues
- CloudFront/S3 access denied problems
- Missing Terraform outputs
- Region mismatches during resource creation
- State consistency concerns between local and CI/CD deployments

These issues are common in real infrastructure work and were part of the hands-on learning and implementation process.

---

## 📈 Skills Demonstrated

This project demonstrates practical ability in:

- **Infrastructure as Code (Terraform)**
- **AWS serverless architecture**
- **CI/CD automation**
- **Cloud deployment debugging**
- **Secure infrastructure design**
- **Environment-aware deployment patterns**
- **Frontend/backend integration**
- **Operational troubleshooting**

---

