Simulated AWS Infrastructure with Docker and Floci📋 OverviewThis project simulates a complete AWS infrastructure using Docker Compose and Floci, including:✅ VPC with CIDR 172.25.0.0/16✅ Public Subnet with CIDR 172.25.1.0/24✅ Internet Gateway✅ Route Table✅ Security Group (firewall)✅ EC2 Instance (Alpine Linux)✅ Working SSH access✅ Floci as an AWS services mock🚀 QuickstartPrerequisitesDocker Desktop installedTerminal/PowerShellGetting StartedBash# Bring up the infrastructure
docker compose up -d

# Wait ~30 seconds for everything to be ready
docker ps

# Access EC2 via SSH
ssh -p 2222 root@localhost
# Password: aws123
📁 Project FilesFileDescriptiondocker-compose.ymlDefinition of the entire infrastructure (VPC, IGW, EC2, Floci)entrypoint.shScript that configures SSH on the EC2 instanceRELATORIO_INFRAESTRUTURA.mdFull report (1-2 pages) explaining each resourceSCREENSHOTS_DOCUMENTACAO.mdSimulated documentation with command outputsCOMANDOS_REFERENCIA.mdComplete guide of useful commandstest-infrastructure.batTest script to validate the infrastructure

🏗️ Architecture┌─────────────────────────────────────────────────┐
│  VPC Network (172.25.0.0/16)                    │
│                                                 │
│  ┌──────────────────────────────────────────┐   │
│  │  Public Subnet (172.25.1.0/24)           │   │
│  │  ┌──────────────────────────────────┐    │   │
│  │  │  EC2 Instance (172.25.1.10)      │    │   │
│  │  │  SSH: localhost:2222             │    │   │
│  │  │  Status: Running ✓               │    │   │
│  │  └──────────────────────────────────┘    │   │
│  └──────────────────────────────────────────┘   │
│                                                 │
│  ┌──────────────────────────────────────────┐   │
│  │  Internet Gateway (172.25.0.1)           │   │
│  │  Status: Running ✓                       │   │
│  └──────────────────────────────────────────┘   │
│                                                 │
│  ┌──────────────────────────────────────────┐   │
│  │  Floci Service (172.25.0.50)             │   │
│  │  API: localhost:4566                     │   │
│  │  Status: Running ✓                       │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
🔑 CredentialsSSH:Host: localhostPort: 2222User: rootPassword: aws123Floci API:URL: http://localhost:4566No authentication (mock)📊 Role of Each ResourceVPC (Virtual Private Cloud)Provides network isolation. All resources communicate within this private network.Public SubnetSubdivides the VPC. Allows logical organization. Subnet IPs: 172.25.1.xInternet GatewayEntry/exit point. Connects the VPC to the external world (simulated). IP: 172.25.0.1Route TableDefines how packets are routed. Default route (0.0.0.0/0) goes to the IGW.Security GroupInstance firewall. Allows SSH (port 22) only from within the VPC.EC2 InstanceCompute server. Alpine Linux running SSH. IP: 172.25.1.10Floci ServiceMock of AWS services (S3, EC2, IAM). Allows testing integration locally.

🧪 TestsCheck statusBashdocker ps
docker network inspect default_vpc_network
Test SSHBashssh -p 2222 root@localhost
Test FlociBashcurl http://localhost:4566/
Verify connectivityBash# Inside the EC2 instance
docker exec -it ec2-lab-instance sh
ping 172.25.0.1   # IGW
ping 172.25.0.50  # Floci
ifconfig          # View IP

📝 Delivery Checklist[x] VPC created (172.25.0.0/16)[x] Public subnet (172.25.1.0/24)[x] Internet Gateway created[x] Route table configured[x] Security Group allowing SSH[x] EC2 instance running[x] SSH access working[x] Floci running[x] Documentation with prints/outputs[x] Report explaining each resource🛑 Stop the EnvironmentBashdocker compose down
🔧 TroubleshootingSSH not connecting?Bashdocker logs ec2-lab-instance   # Check if SSH started
docker ps | grep ec2-lab       # Verify if container is running
Floci not responding?Bashdocker logs floci-service      # View logs
curl -v http://localhost:4566  # Debug curl
Network not working?Bashdocker network inspect default_vpc_network
docker ps --format "{{.Names}}\t{{.Status}}"

📚 Complete DocumentationSee:RELATORIO_INFRAESTRUTURA.md - Full academic reportSCREENSHOTS_DOCUMENTACAO.md - Command outputsCOMANDOS_REFERENCIA.md - Guide of all commands✅ StatusVPC ..................... ✓
Subnet .................. ✓
Internet Gateway ........ ✓
Route Table ............. ✓
Security Group .......... ✓
EC2 Instance ............ ✓ (Healthy)
SSH Access .............. ✓ (Working)
Floci Service ........... ✓ (Healthy)

Overall Status: ✓ ALL GREEN
Date: 2026-11-09Technology: Docker + FlociObjective: Simulation of AWS infrastructure for educational purposesStatus: Fully operational
