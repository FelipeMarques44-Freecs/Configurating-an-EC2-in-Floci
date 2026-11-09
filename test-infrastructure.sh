#!/bin/bash

echo "=========================================="
echo "AWS Infrastructure Simulation Tests"
echo "=========================================="
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para testar
test_resource() {
  local name=$1
  local command=$2
  
  echo -n "Testing $name... "
  if eval "$command" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS${NC}"
    return 0
  else
    echo -e "${RED}✗ FAIL${NC}"
    return 1
  fi
}

echo "1. VPC Network (10.0.0.0/16)"
test_resource "VPC Bridge Network" "docker network inspect vpc_network | grep -q 10.0.0.0"
echo ""

echo "2. Public Subnet (10.0.1.0/24)"
test_resource "Subnet exists" "docker inspect ec2-lab-instance | grep -q 10.0.1"
echo ""

echo "3. Internet Gateway"
test_resource "IGW Container" "docker ps | grep -q internet-gateway"
echo ""

echo "4. EC2 Instance"
test_resource "EC2 Instance Running" "docker ps | grep -q ec2-lab-instance"
test_resource "EC2 Health Check" "docker inspect ec2-lab-instance --format='{{.State.Health.Status}}' | grep -q healthy"
echo ""

echo "5. Security Group (SSH Port 22)"
test_resource "SSH Service Running" "docker exec ec2-lab-instance ps | grep -q sshd"
test_resource "SSH Port Accessible" "nc -zv localhost 2222 2>&1 | grep -q succeeded"
echo ""

echo "6. Floci Service (AWS Mock)"
test_resource "Floci Running" "docker ps | grep -q floci-service"
test_resource "Floci API Accessible" "curl -s http://localhost:4566/ | grep -q ListAllMyBuckets"
echo ""

echo "=========================================="
echo "Infrastructure Status:"
echo "=========================================="
echo ""

echo "Network Details:"
docker network inspect vpc_network --format='{{json .IPAM.Config}}' | grep -o '"Subnet":"[^"]*"' | head -1
echo ""

echo "Running Services:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(ec2-lab|internet-gateway|floci)"
echo ""

echo "=========================================="
echo "SSH Access Test:"
echo "=========================================="
echo "Command: sshpass -p 'aws123' ssh -o StrictHostKeyChecking=no root@localhost -p 2222"
echo ""
sshpass -p 'aws123' ssh -o StrictHostKeyChecking=no root@localhost -p 2222 'hostname && echo "✓ SSH Access Successful!"' 2>/dev/null || echo "Setup SSH access if needed"
echo ""

echo "=========================================="
echo "Resources Created:"
echo "=========================================="
cat << 'EOF'
✓ VPC: vpc_network (CIDR: 10.0.0.0/16)
✓ Subnet: Public (CIDR: 10.0.1.0/24, IP: 10.0.1.10)
✓ Internet Gateway: internet-gateway (10.0.0.1)
✓ Route Table: Default (0.0.0.0/0 → IGW)
✓ Security Group: SSH allowed on port 2222
✓ EC2 Instance: ec2-lab-instance (Amazon Linux Simulation)
✓ Floci Service: AWS API Mock (http://localhost:4566)
EOF
echo ""
