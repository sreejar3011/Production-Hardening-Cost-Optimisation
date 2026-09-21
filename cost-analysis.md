# Production Hardening: Cost Analysis & Optimisation Sprint

## 1. Multi-Tier Cost Estimation (Monthly)
Across our 4 microservice projects, costs scale primarily based on AWS Lambda executions, API Gateway requests, and DynamoDB read/write capacities.

| Project Name | Tier A (10 users/day) | Tier B (500 users/day) | Tier C (5,000 users/day) |
| :--- | :--- | :--- | :--- |
| **Project 1** | $0.20 / month | $4.50 / month | $45.00 / month |
| **Project 2** | $0.35 / month | $7.20 / month | $72.00 / month |
| **Project 3** | $0.15 / month | $3.00 / month | $30.00 / month |
| **Project 4** | $0.50 / month | $10.00 / month | $100.00 / month |

## 2. Resource Optimisation Strategies
* **Provisioned Concurrency Review:** Removed unused provisioned concurrency on low-traffic Lambda functions to avoid idle billing.
* **DynamoDB Billing Mode:** Shifted non-critical tables from Provisioned to On-Demand capacity to prevent over-provisioning waste.
* **CloudWatch Log Retention:** Capped log retention at 14 days across all log groups to minimize long-term S3/Glacier storage overhead.

## 3. Cost Optimisation Implemented
* Enabled API Gateway caching for repetitive read-heavy endpoints.
* Configured AWS Budgets alerts to trigger an SNS notification if monthly projected spend exceeds 80% of the target threshold.