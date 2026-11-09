@echo off
REM Script de testes para infraestrutura AWS simulada com Floci
REM Windows PowerShell compatible

echo.
echo ==========================================
echo AWS Infrastructure Simulation Tests
echo ==========================================
echo.

REM Test 1: VPC Network
echo [1/6] Testing VPC Network (172.25.0.0/16)...
docker network inspect vpc_network > nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] VPC Network exists
) else (
    echo [FAIL] VPC Network not found
)
echo.

REM Test 2: EC2 Instance running
echo [2/6] Testing EC2 Instance...
docker ps | findstr ec2-lab-instance > nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] EC2 Instance (ec2-lab-instance) is running
) else (
    echo [FAIL] EC2 Instance not running
)
echo.

REM Test 3: SSH Server
echo [3/6] Testing SSH Server on EC2...
docker exec ec2-lab-instance ps aux | findstr sshd > nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] SSH Server is running on EC2 instance
) else (
    echo [FAIL] SSH Server not running
)
echo.

REM Test 4: Port mapping
echo [4/6] Testing Port Mapping (2222)...
docker port ec2-lab-instance | findstr 2222 > nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] SSH port 2222 is mapped correctly
) else (
    echo [FAIL] SSH port mapping failed
)
echo.

REM Test 5: Internet Gateway
echo [5/6] Testing Internet Gateway...
docker ps | findstr internet-gateway > nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] Internet Gateway container is running
) else (
    echo [FAIL] Internet Gateway not running
)
echo.

REM Test 6: Floci Service
echo [6/6] Testing Floci Service...
docker ps | findstr floci-service > nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] Floci Service is running
) else (
    echo [FAIL] Floci Service not running
)
echo.

REM Summary
echo ==========================================
echo Infrastructure Summary:
echo ==========================================
echo.

echo Running containers:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | findstr /E "(ec2|gateway|floci)"
echo.

echo Network Configuration:
echo - VPC Network: 172.25.0.0/16
echo - Public Subnet: 172.25.1.0/24
echo - EC2 Instance IP: 172.25.1.10
echo - Internet Gateway IP: 172.25.0.1
echo - Floci Service IP: 172.25.0.50
echo.

echo ==========================================
echo SSH Access Instructions:
echo ==========================================
echo.
echo Command: ssh -p 2222 root@localhost
echo Password: aws123
echo.
echo Or use sshpass (if installed):
echo sshpass -p aws123 ssh -o StrictHostKeyChecking=no root@localhost -p 2222
echo.

pause
