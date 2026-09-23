# Project 4 – Observability

## Project

**AI-Powered Resume Screener & Talent Acquisition Pipeline**

This document records the observability configuration implemented for Project 4 as part of the Production Hardening, Observability & Cost Optimisation Sprint.

## 1. AWS X-Ray Tracing

AWS X-Ray tracing was enabled for the Project 4 Lambda functions to provide distributed tracing and visibility into application requests.

The following Lambda functions were configured with X-Ray service tracing:

- `generate-presigned-url`
- `recruiter-data-service`
- `sqs-resume-worker`
- `update-candidate-status`
- `s3-to-sqs-dispatcher`

X-Ray tracing was also enabled for the `prod` stage of the `resume-screener-api` API Gateway.

### End-to-End Flow

The tested upload URL request produced the following trace path:

```text
Client
  ↓
API Gateway – resume-screener-api/prod
  ↓
Lambda – generate-presigned-url