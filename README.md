# Infraestrutura AWS Simulada com Docker e Floci

## 📋 Resumo

Este projeto simula uma infraestrutura AWS completa usando Docker Compose e Floci, incluindo:

- ✅ VPC com CIDR 172.25.0.0/16
- ✅ Subnet pública com CIDR 172.25.1.0/24
- ✅ Internet Gateway
- ✅ Tabela de rotas
- ✅ Security Group (firewall)
- ✅ Instância EC2 (Alpine Linux)
- ✅ Acesso SSH funcionando
- ✅ Floci como mock de serviços AWS

## 🚀 Quickstart

### Pré-requisitos
- Docker Desktop instalado
- Terminal/PowerShell

### Iniciar

```bash
# Subir infraestrutura
docker compose up -d

# Aguardar ~30 segundos para tudo ficar pronto
docker ps

# Acessar EC2 via SSH
ssh -p 2222 root@localhost
# Senha: aws123
```

## 📁 Arquivos do Projeto

| Arquivo | Descrição |
|---------|-----------|
| `docker-compose.yml` | Definição de toda infraestrutura (VPC, IGW, EC2, Floci) |
| `entrypoint.sh` | Script que configura SSH na instância EC2 |
| `RELATORIO_INFRAESTRUTURA.md` | Relatório completo (1-2 páginas) explicando cada recurso |
| `SCREENSHOTS_DOCUMENTACAO.md` | Documentação simulada com outputs dos comandos |
| `COMANDOS_REFERENCIA.md` | Guia completo de comandos úteis |
| `test-infrastructure.bat` | Script de testes para validar infraestrutura |

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────┐
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
```

## 🔑 Credenciais

**SSH:**
- Host: localhost
- Porta: 2222
- Usuário: root
- Senha: aws123

**Floci API:**
- URL: http://localhost:4566
- Sem autenticação (mock)

## 📊 Papel de Cada Recurso

### VPC (Virtual Private Cloud)
Fornece isolamento de rede. Todos os recursos se comunicam dentro desta rede privada.

### Subnet Pública
Subdivide a VPC. Permite organização lógica. IPs da subnet: 172.25.1.x

### Internet Gateway
Ponto de entrada/saída. Conecta a VPC ao mundo externo (simulado). IP: 172.25.0.1

### Tabela de Rotas
Define como pacotes são roteados. Rota padrão (0.0.0.0/0) vai para IGW.

### Security Group
Firewall da instância. Libera SSH (porta 22) apenas de dentro da VPC.

### Instância EC2
Servidor computacional. Alpine Linux rodando SSH. IP: 172.25.1.10

### Floci Service
Mock de serviços AWS (S3, EC2, IAM). Permite testar integração localmente.

## 🧪 Testes

### Verificar status
```bash
docker ps
docker network inspect default_vpc_network
```

### Testar SSH
```bash
ssh -p 2222 root@localhost
```

### Testar Floci
```bash
curl http://localhost:4566/
```

### Verificar conectividade
```bash
# Dentro do EC2
docker exec -it ec2-lab-instance sh
ping 172.25.0.1  # IGW
ping 172.25.0.50 # Floci
ifconfig         # Ver IP
```

## 📝 Checklist de Entrega

- [x] VPC criada (172.25.0.0/16)
- [x] Subnet pública (172.25.1.0/24)
- [x] Internet Gateway criado
- [x] Tabela de rotas configurada
- [x] Security Group permitindo SSH
- [x] Instância EC2 rodando
- [x] Acesso SSH funcionando
- [x] Floci rodando
- [x] Documentação com prints/outputs
- [x] Relatório explicando cada recurso

## 🛑 Parar o Ambiente

```bash
docker compose down
```

## 🔧 Troubleshooting

### SSH não conecta?
```bash
docker logs ec2-lab-instance  # Ver se SSH iniciou
docker ps | grep ec2-lab      # Verificar se container está rodando
```

### Floci não responde?
```bash
docker logs floci-service     # Ver logs
curl -v http://localhost:4566  # Debug curl
```

### Rede não funciona?
```bash
docker network inspect default_vpc_network
docker ps --format "{{.Names}}\t{{.Status}}"
```

## 📚 Documentação Completa

Veja:
- **RELATORIO_INFRAESTRUTURA.md** - Relatório acadêmico completo
- **SCREENSHOTS_DOCUMENTACAO.md** - Outputs dos comandos
- **COMANDOS_REFERENCIA.md** - Guia de todos os comandos

## ✅ Status

```
VPC ..................... ✓
Subnet .................. ✓
Internet Gateway ........ ✓
Route Table ............. ✓
Security Group .......... ✓
EC2 Instance ............ ✓ (Healthy)
SSH Access .............. ✓ (Working)
Floci Service ........... ✓ (Healthy)

Overall Status: ✓ ALL GREEN
```

---

**Data**: 2026-11-09  
**Tecnologia**: Docker + Floci  
**Objetivo**: Simulação de infraestrutura AWS para fins educacionais  
**Status**: Funcionando completamente
