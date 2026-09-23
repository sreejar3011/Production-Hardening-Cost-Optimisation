# Project 2: Operations & Incident Response Runbook

## 1. Overview
This runbook outlines the standard operating procedures, alarm monitoring thresholds, and incident resolution steps for Project 2 microservices. Project 2 utilizes AWS Lambda for compute execution.

## 2. Critical CloudWatch Alarms & Thresholds
* **API Error Rate Spike (`project2-api-error-rate-alarm`):** Triggered when the HTTP 5xx error rate exceeds **5%** over a 5-minute period.
  * *Action:* Inspect API Gateway error logs, check downstream services, and notify via the `project2-alerts` SNS topic.
* **P95 Latency Threshold (`project2-p95-latency-alarm`):** Triggered when the P95 latency exceeds **3 seconds** over a 5-minute period.
  * *Action:* Analyze Lambda execution durations and bottleneck traces, notify via the `project2-alerts` SNS topic.

## 3. Notification Target Configuration
* **SNS Topic:** All alarms are explicitly configured to route notifications to the `project2-alerts` SNS topic ARN, ensuring immediate delivery to the on-call pager.

## 4. Rollback Procedure
* **Execution:** In the event of a critical failure or sustained error spike, automated or manual rollback is executed via the deployment pipeline by reverting to the previous stable Lambda version artifact.

## 5. Incident Escalation Workflow
1. **Paging:** Automated alerts fire to the on-call engineer via the `project2-alerts` SNS topic.
2. **Triage:** Acknowledge the alert within 10 minutes and check the CloudWatch dashboard.
3. **Mitigation:** Execute rollback procedures or scale up compute resources if load-related.
4. **Post-Mortem:** Document root cause and preventative actions within 24 hours of resolution.