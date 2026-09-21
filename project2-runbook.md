# Project 2: Operations & Incident Response Runbook

## 1. Overview
This runbook outlines the standard operating procedures, alarm monitoring thresholds, and incident resolution steps for Project 2 microservices.

## 2. Critical CloudWatch Alarms
* **High CPU Utilization:** Triggered when CPU exceeds 85% for 3 consecutive 5-minute periods. 
  * *Action:* Check ECS/Lambda metrics and review recent deployment logs.
* **API 5xx Error Rate Spike:** Triggered when HTTP 5xx responses exceed 5% of total traffic over 2 minutes.
  * *Action:* Inspect API Gateway error logs and downstream database connection pools.

## 3. Incident Escalation Workflow
1. **Paging:** Automated alerts fire to the on-call engineer via PagerDuty/SNS.
2. **Triage:** Acknowledge the alert within 10 minutes and check the CloudWatch dashboard.
3. **Mitigation:** Execute rollback procedures or scale up compute resources if load-related.
4. **Post-Mortem:** Document root cause and preventative actions within 24 hours of resolution.