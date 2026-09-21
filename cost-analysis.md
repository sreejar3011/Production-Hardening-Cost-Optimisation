# AWS Cost Analysis & Optimization Report (Across Projects)

## 1. Executive Summary & Cost Overview
* **Total Cost (Last 6 Months):** $64.94[cite: 8]
* **Average Monthly Cost:** $10.82[cite: 8]
* **Active Services Tracked:** 16 services[cite: 8]
* **Billing Period Analyzed:** March 1, 2026 – August 31, 2026[cite: 8]

## 2. Cost Breakdown by Service
| Service | Total Cost ($) | August 2026 Cost ($) | Usage Context / Notes |
| :--- | :--- | :--- | :--- |
| **AWS Step Functions** | $54.57[cite: 8] | $54.57[cite: 8] | Primary cost driver across workflows and state transitions. |
| **Tax** | $9.90[cite: 8] | $9.90[cite: 8] | Applicable regional taxes. |
| **Amazon DynamoDB** | $0.34[cite: 8] | $0.34[cite: 8] | Low-cost NoSQL database storage and read/write operations. |
| **AWS Secrets Manager** | $0.11[cite: 8] | $0.11[cite: 8] | Secret storage and rotation tracking. |
| **Amazon S3** | $0.01[cite: 8] | $0.01[cite: 8] | Minimal object storage usage. |
| **Other Services (SES, WAF, CloudTrail, Glue, Lambda, API Gateway, SQS, SNS, CloudWatch, KMS)** | $0.00[cite: 8, 9] | $0.00[cite: 8, 9] | Operating entirely within free tier limits or idle. |

## 3. Free Tier Utilization Status
* **Service Offers in Use:** 21 service offers active under the AWS Free Tier[cite: 10].
* **Key Workload Usage Metrics:**
  * **Amazon S3 (Requests):** ~1,224 requests (61.20% of the monthly free tier tier-1 limit)[cite: 10].
  * **Amazon SQS:** 181,204 requests (18.12% of the free tier allowance)[cite: 10].
  * **Amazon Textract:** 22 pages processed (2.20% utilization)[cite: 10].
  * **Amazon CloudWatch:** 0 GB metrics storage and 8 minutes of log ingestion, well under free tier ceilings[cite: 10].

## 4. Optimization Recommendations & Action Items
1. **Step Functions Optimization:** Since Step Functions account for the vast majority ($54.57) of total spending[cite: 8], audit workflow transition counts, eliminate redundant state polls, and optimize execution payloads to reduce state transition fees.
2. **Resource Governance:** Maintain current tagging practices across all four projects to ensure precise cost attribution in future billing cycles.
3. **Free Tier Monitoring:** Continue tracking SQS and S3 usage growth against free tier thresholds to prevent unexpected overage charges as project traffic scales.