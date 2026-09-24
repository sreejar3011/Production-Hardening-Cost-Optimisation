# Project 1 – Alarm Runbook

## Project

**Employee Onboarding Demo Project**

This runbook documents the alerting and incident-response configuration implemented for Project 1 as part of the Production Hardening, Observability & Cost Optimisation Sprint.

> Note: The original Project 1 AWS resources had previously been removed. A minimal validation Lambda named `project1-alarm-test` was therefore created solely to validate the required CloudWatch alarm and notification behaviour without recreating the complete Employee Onboarding application infrastructure.

---

## 1. Alerting Architecture

The Project 1 alarm validation environment uses the following components:

```text
project1-alarm-test Lambda
        │
        ├── Errors / Invocations
        │       │
        │       ▼
        │   Error Rate Alarm
        │
        └── Duration (P95)
                │
                ▼
          P95 Duration Alarm
                │
                ▼
        Amazon CloudWatch
                │
                ▼
          Amazon SNS Topic
          `project1-alarms`
                │
                ▼
          Email Notification