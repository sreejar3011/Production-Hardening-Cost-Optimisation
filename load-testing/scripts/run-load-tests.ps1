<#
.SYNOPSIS
    Automated execution script for Task 6 Artillery Load Testing across Sprint microservices.

.DESCRIPTION
    Runs Artillery load tests for available microservice endpoints (50 concurrent VUs for 60 seconds).
    Automatically skips unavailable projects and records raw test results into load-testing/results/.

.PARAMETER Project
    Specific project to test (1, 2, 3, 4, or "all"). Default is "all".
#>

param (
    [string]$Project = "all"
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BaseDir = Split-Path -Parent $ScriptDir
$ConfigsDir = Join-Path $BaseDir "configs"
$ResultsDir = Join-Path $BaseDir "results"

if (-not (Test-Path $ResultsDir)) {
    New-Item -ItemType Directory -Path $ResultsDir -Force | Out-Null
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Task 6: Artillery Production Load Testing Runner" -ForegroundColor Cyan
Write-Host "Duration: 60s | Concurrency: 50 Virtual Users" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Environment variable defaults
if (-not $env:PROJECT4_API_URL) {
    $env:PROJECT4_API_URL = "https://zxqd62sqw9.execute-api.ap-south-1.amazonaws.com/prod"
}

# Function to run an Artillery test
function Invoke-ProjectTest {
    param (
        [string]$ProjectNumber,
        [string]$ProjectName,
        [string]$ConfigFile,
        [string]$EnvVarName,
        [string]$DefaultUrl
    )

    $targetUrl = [Environment]::GetEnvironmentVariable($EnvVarName)
    if (-not $targetUrl -and $DefaultUrl) {
        $targetUrl = $DefaultUrl
        [Environment]::SetEnvironmentVariable($EnvVarName, $DefaultUrl)
    }

    Write-Host "`n------------------------------------------------------------" -ForegroundColor Yellow
    Write-Host "Evaluating Project $($ProjectNumber): $ProjectName" -ForegroundColor Yellow
    Write-Host "------------------------------------------------------------" -ForegroundColor Yellow

    if (-not $targetUrl) {
        Write-Host "[-] Status: UNAVAILABLE - No active endpoint configured ($EnvVarName not set)." -ForegroundColor Red
        Write-Host "    Skipping Project $ProjectNumber execution per sprint inventory." -ForegroundColor DarkGray
        return
    }

    Write-Host "[+] Target Endpoint: $targetUrl" -ForegroundColor Green
    Write-Host "[*] Executing pre-flight reachability check..." -ForegroundColor Cyan

    try {
        $probe = Invoke-WebRequest -Uri $targetUrl -Method Get -TimeoutSec 10 -UseBasicParsing
        Write-Host "    Pre-flight response status: $($probe.StatusCode) ($($probe.StatusDescription))" -ForegroundColor Cyan
    } catch [System.Net.WebException] {
        $res = $_.Exception.Response
        if ($res) {
            $statusCode = [int]$res.StatusCode
            Write-Host "    Pre-flight response status: $statusCode ($($res.StatusDescription))" -ForegroundColor Cyan
        } else {
            Write-Host "[-] Pre-flight check failed: $_" -ForegroundColor Red
            return
        }
    } catch {
        Write-Host "[-] Pre-flight check failed: $_" -ForegroundColor Red
        return
    }

    $outputJson = Join-Path $ResultsDir "project$ProjectNumber-artillery-result.json"
    $outputHtml = Join-Path $ResultsDir "project$ProjectNumber-report.html"
    $configPath = Join-Path $ConfigsDir $ConfigFile

    Write-Host "[*] Launching Artillery load test (60s duration, 50 concurrency)..." -ForegroundColor Green
    
    $cmd = "npx artillery run `"$configPath`" --output `"$outputJson`""
    Invoke-Expression $cmd

    if (Test-Path $outputJson) {
        Write-Host "[+] Raw Artillery JSON report saved: $outputJson" -ForegroundColor Green
        try {
            $rawJson = Get-Content $outputJson -Raw | ConvertFrom-Json
            $agg = $rawJson.aggregate
            Write-Host "`n--- Execution Summary for Project $($ProjectNumber) ---" -ForegroundColor Cyan
            Write-Host "Total Requests:      $($agg.counters.'http.requests')"
            Write-Host "Request Rate:        $($agg.rates.'http.request_rate') req/sec"
            Write-Host "P50 Latency:         $($agg.summaries.'http.response_time'.p50) ms"
            Write-Host "P95 Latency:         $($agg.summaries.'http.response_time'.p95) ms"
            Write-Host "P99 Latency:         $($agg.summaries.'http.response_time'.p99) ms"
            Write-Host "Min Latency:         $($agg.summaries.'http.response_time'.min) ms"
            Write-Host "Max Latency:         $($agg.summaries.'http.response_time'.max) ms"
            Write-Host "Completed VUs:       $($agg.counters.'vusers.completed')"
            Write-Host "Failed VUs:          $($agg.counters.'vusers.failed')"
        } catch {
            Write-Host "[!] Note: Could not parse summary metrics: $_" -ForegroundColor DarkGray
        }
    }
}

# Execution Router
if ($Project -eq "all" -or $Project -eq "1") {
    Invoke-ProjectTest -ProjectNumber "1" -ProjectName "Employee Onboarding" -ConfigFile "project1.yml" -EnvVarName "PROJECT1_API_URL" -DefaultUrl ""
}

if ($Project -eq "all" -or $Project -eq "2") {
    Invoke-ProjectTest -ProjectNumber "2" -ProjectName "Smart Leave & Absence Management" -ConfigFile "project2.yml" -EnvVarName "PROJECT2_API_URL" -DefaultUrl ""
}

if ($Project -eq "all" -or $Project -eq "3") {
    Invoke-ProjectTest -ProjectNumber "3" -ProjectName "Employee Learning & Skill Certificate Tracker" -ConfigFile "project3.yml" -EnvVarName "PROJECT3_API_URL" -DefaultUrl ""
}

if ($Project -eq "all" -or $Project -eq "4") {
    Invoke-ProjectTest -ProjectNumber "4" -ProjectName "AI Resume Screener & Talent Pipeline" -ConfigFile "project4.yml" -EnvVarName "PROJECT4_API_URL" -DefaultUrl "https://zxqd62sqw9.execute-api.ap-south-1.amazonaws.com/prod"
}

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "Artillery Load Testing Run Completed." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
