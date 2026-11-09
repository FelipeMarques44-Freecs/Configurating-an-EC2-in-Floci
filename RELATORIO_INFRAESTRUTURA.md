# Relatório de Infraestrutura AWS Simulada com Floci

## 1. Introdução

Este relatório documenta a simulação de uma infraestrutura AWS utilizando Docker Compose e Floci. O objetivo foi replicar os principais recursos de rede e computação (VPC, subnet, Internet Gateway, EC2, Security Group) em um ambiente containerizado para fins educacionais e de teste.

## 2. Visão Geral da Solução

Em vez de utilizar a AWS de verdade, optamos por simular toda a infraestrutura utilizando containers Docker, que oferece as seguintes vantagens:

- **Custo zero**: Não requer conta AWS ou gasto em recursos
- **Velocidade**: Ambiente pronto em segundos
- **Portabilidade**: Funciona em qualquer máquina com Docker
- **Educacional**: Permite entender a arquitetura sem abstrações da AWS

## 3. Recursos Criados

### 3.1 VPC (Virtual Private Cloud)
- **CIDR**: 172.25.0.0/16
- **Tipo**: Docker Bridge Network
- **Função**: Fornece isolamento de rede e comunicação entre containers
- **Implementação**: Rede Docker personalizada com subnet configurada

```
Comando: docker network create vpc_network --subnet=172.25.0.0/16
```

### 3.2 Subnet Pública
- **CIDR**: 172.25.1.0/24
- **IP Atribuído (EC2)**: 172.25.1.10
- **Função**: Subdivide a VPC em segmentos de rede; permite organização lógica dos recursos

### 3.3 Internet Gateway
- **Container**: internet-gateway
- **IP**: 172.25.0.1
- **Função**: Simula o ponto de entrada para tráfego externo; responsável por rotear pacotes para fora da VPC

### 3.4 Tabela de Rotas
- **Rota**: 0.0.0.0/0 → Internet Gateway (172.25.0.1)
- **Função**: Define como o tráfego é roteado; qualquer pacote destinado a redes externas segue para o IGW

### 3.5 Security Group
- **Regra**: SSH (porta 22) liberada em localhost:2222
- **Origem**: My IP (127.0.0.1 neste caso)
- **Função**: Atua como firewall; controla quais conexões são permitidas para a instância EC2

### 3.6 Instância EC2
- **Container**: ec2-lab-instance
- **Imagem**: Alpine Linux (simulando Amazon Linux 2)
- **IP Privado**: 172.25.1.10
- **Portas**: SSH na porta 2222 (mapeado do container 22)
- **Serviço**: SSH Server (sshd) rodando
- **Função**: Servidor computacional na nuvem; aceita conexões SSH

### 3.7 Floci Service
- **Imagem**: floci/floci:1.5.13
- **IP**: 172.25.0.50
- **Porta**: 4566
- **Função**: Mock de serviços AWS (S3, EC2, IAM); permite testar integração com AWS de forma local

## 4. Arquitetura de Rede

```
┌─────────────────────────────────────────────────┐
│  VPC Network (172.25.0.0/16)                    │
│                                                 │
│  ┌──────────────────────────────────────────┐   │
│  │  Public Subnet (172.25.1.0/24)           │   │
│  │                                          │   │
│  │  ┌──────────────────────────────────┐    │   │
│  │  │  EC2 Instance                    │    │   │
│  │  │  IP: 172.25.1.10                │    │   │
│  │  │  SSH: 2222 (host) → 22 (guest)  │    │   │
│  │  │  Status: Running (healthy)      │    │   │
│  │  └──────────────────────────────────┘    │   │
│  └──────────────────────────────────────────┘   │
│                                                 │
│  ┌──────────────────────────────────────────┐   │
│  │  Internet Gateway (172.25.0.1)           │   │
│  │  Status: Running                         │   │
│  └──────────────────────────────────────────┘   │
│                                                 │
│  ┌──────────────────────────────────────────┐   │
│  │  Floci Service (172.25.0.50)             │   │
│  │  AWS Mock API: Port 4566                 │   │
│  │  Status: Running (healthy)               │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
           ↓ SSH Access via Port 2222
       Host Machine (127.0.0.1)
```

## 5. Como Acessar a Instância EC2 via SSH

**Comando**:
```bash
ssh -p 2222 root@localhost
```

**Credenciais**:
- Usuário: `root`
- Senha: `aws123`

**Exemplo de conexão bem-sucedida**:
```
$ ssh -p 2222 root@localhost
The authenticity of host '[localhost]:2222 ([127.0.0.1]:2222)' can't be established.
ED25519 key fingerprint is SHA256:twpz/9VCgCZKw1bzTUNphAvmHdHOwKg72dndhCr1DzA.
root@localhost's password: [enter: aws123]
Welcome to Alpine Linux v3.20
Kernel 6.2.0 on x86_64
ec2-lab-instance:~#
```

## 6. Verificação de Recursos

### 6.1 Listar todos os containers da VPC
```bash
docker ps --filter "network=vpc_network"
```

### 6.2 Inspecionar a rede
```bash
docker network inspect vpc_network
```

### 6.3 Ver logs da instância EC2
```bash
docker logs ec2-lab-instance
```

### 6.4 Testar acesso à API Floci
```bash
curl http://localhost:4566/
```

## 7. Comparação: Simulação vs AWS Real

| Aspecto | AWS Real | Simulação (Floci) |
|---------|----------|------------------|
| **Custo** | $0.0116/hora (t2.micro) | $0 |
| **Tempo de setup** | 5-10 minutos | < 30 segundos |
| **Rede** | VPC real com BGP/routing global | Docker bridge network |
| **Instância** | Hardware físico virtualizado | Container leve |
| **Acesso** | ssh root@IP_PÚBLICO | ssh -p 2222 localhost |
| **SSH Key** | Arquivo .pem necessário | Senha configurada |
| **Escalabilidade** | Global, multi-região | Local apenas |
| **Educacional** | Não didático, abstrações | Transparente, compreensível |

## 8. Conclusão

A simulação de infraestrutura AWS com Docker e Floci oferece uma solução eficaz para fins educacionais e testes. Todos os principais componentes foram replicados de forma funcional:

✓ VPC com subnetting funcionando  
✓ Internet Gateway simulado  
✓ Security Group (firewall) ativo  
✓ Instância EC2 acessível via SSH  
✓ Roteamento entre componentes operacional  
✓ Floci como mock de serviços AWS  

Esta abordagem permite compreender a arquitetura de rede em nuvem de forma prática, segura e educacional.

---

**Data**: 2026-11-09  
**Ambiente**: Docker Desktop + Floci 1.5.13  
**Status**: ✓ Tudo Funcionando
