# Task 6: Artillery Production Load Testing

This directory contains the automated Artillery load testing suite, scenario configurations, and performance evaluation artifacts for the Production Hardening & Cost Optimisation Sprint.

---

## 1. Directory Structure

```text
load-testing/
├── README.md                      # Operational guide, execution instructions & interpretation
├── configs/                       # Artillery YAML scenario configurations
│   ├── project1.yml               # Project 1 (Employee Onboarding - Template/Unavailable)
│   ├── project2.yml               # Project 2 (Smart Leave Management - Template/Unavailable)
│   ├── project3.yml               # Project 3 (Certificate Tracker - Template/Unavailable)
│   └── project4.yml               # Project 4 (AI Resume Screener - Active Tested Endpoint)
├── scripts/
│   └── run-load-tests.ps1         # Automated PowerShell test runner
├── results/                       # Raw Artillery test output artifacts
│   ├── .gitkeep
│   └── project4-artillery-result.json # Raw benchmark measurements from 60s load test
└── reports/
    └── ARTILLERY_LOAD_TEST_REPORT.md  # Official sprint load testing report & 10x scaling analysis
```

---

## 2. Prerequisites & Installation

### Node.js & npm
Ensure Node.js (v18+) and npm are installed on the local system:

```powershell
node -v
npm -v
```

### Installing Artillery
Artillery can be executed directly using `npx` (no global installation required):

```powershell
npx artillery --version
```

Or installed globally via npm:

```powershell
npm install -g artillery@latest
```

---

## 3. Environment Variables & Endpoint Configuration

To prevent hardcoding sensitive or changing infrastructure URLs, all Artillery configurations use environment variable expansion:

| Environment Variable | Target Project | Default / Target URL | Status |
|---|---|---|---|
| `PROJECT1_API_URL` | Project 1 (Employee Onboarding) | *None* | Unavailable (Resources decommissioned) |
| `PROJECT2_API_URL` | Project 2 (Smart Leave Management) | *None* | Unavailable (No public API Gateway deployed) |
| `PROJECT3_API_URL` | Project 3 (Certificate Tracker) | *None* | Unavailable (No public API Gateway deployed) |
| `PROJECT4_API_URL` | Project 4 (AI Resume Screener) | `https://zxqd62sqw9.execute-api.ap-south-1.amazonaws.com/prod` | **Active & Tested** |

To override an endpoint prior to running tests:

```powershell
$env:PROJECT4_API_URL = "https://your-custom-api-id.execute-api.ap-south-1.amazonaws.com/prod"
```

---

## 4. How to Execute Load Tests

### Automated PowerShell Runner (Recommended)
Use the automated runner script to test specific projects or evaluate the entire inventory:

```powershell
# Run load test for Project 4 (60s duration, 50 concurrency)
powershell -ExecutionPolicy Bypass -File .\load-testing\scripts\run-load-tests.ps1 -Project 4

# Run against all configured projects (automatically skips unavailable endpoints)
powershell -ExecutionPolicy Bypass -File .\load-testing\scripts\run-load-tests.ps1 -Project all
```

### Direct Artillery Execution
You can also invoke Artillery directly against individual configuration files:

```powershell
# Run Project 4 load test and capture raw JSON output
npx artillery run .\load-testing\configs\project4.yml --output .\load-testing\results\project4-artillery-result.json
```

---

## 5. Load Model & Concurrency Explained

The sprint requirement specifies **50 concurrent requests for 60 seconds**.

In Artillery:
- **`arrivalRate: 50`**: Schedules 50 new virtual user arrivals per second.
- **`maxVusers: 50`**: Enforces a strict ceiling of **50 active in-flight virtual users**. If 50 requests are already awaiting response, new virtual users are queued/skipped rather than unbounded growth.
- **`duration: 60`**: Sustains this load profile for an exact 60-second measurement window.

---

## 6. Safety & Security Requirements

1. **Non-Destructive Testing:** Never run sustained concurrent write operations (`POST`/`DELETE`) that mutate persistent production data.
2. **Cognito Authorizer Safety:** In Project 4, endpoints are protected by Amazon Cognito User Pool Authorizers. Unauthenticated requests are evaluated at the API Gateway layer, verifying edge throughput without populating databases with synthetic spam.
3. **Pre-flight Probe:** Always perform a single HTTP probe before starting a load test to confirm target health.
4. **Secret Hygiene:** Never commit `.env` files, API keys, bearer tokens, or AWS credentials to version control.

---

## 7. Interpreting Latency Metrics (P50, P95, P99)

- **P50 (Median):** 50% of all requests completed faster than this time. Represents typical end-user experience.
- **P95:** 95% of requests completed faster than this time. Captures peak execution times during minor network or connection delays.
- **P99:** 99% of requests completed faster than this time. Highlights worst-case tail latency caused by resource queuing, cold starts, or edge contention.

### Project 4 Benchmark Summary
- **Requests:** 1,745 over 60 seconds (36 req/sec sustained)
- **P50:** 219.2 ms
- **P95:** 871.5 ms
- **P99:** 1,274.3 ms
- **Errors:** 0 server errors (HTTP 5xx = 0, HTTP 429 = 0)

---

## 8. Final Report Location

The complete, evidence-based performance audit and 10x scaling recommendations are documented in:

👉 [`reports/ARTILLERY_LOAD_TEST_REPORT.md`](file:///d:/F13%20Tech%20aws%20cloud/Prod%20hardng%20cost%20opt/load-testing/reports/ARTILLERY_LOAD_TEST_REPORT.md)
