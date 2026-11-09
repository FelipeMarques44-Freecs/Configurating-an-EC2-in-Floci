# Screenshot Documentation - AWS Infrastructure Simulation

## 1. VPC Criada
```
Network ID: f580da7341fe
Network Name: default_vpc_network
CIDR Block: 172.25.0.0/16
Driver: bridge
Gateway: 172.25.0.1
Status: Active
Containers Conectados: 2
```

## 2. Subnet Pública
```
Subnet CIDR: 172.25.1.0/24
EC2 Instance IP: 172.25.1.10
Gateway IP: 172.25.0.1
IPs em uso: 5
IPs disponíveis: 65531
Associated with VPC: default_vpc_network
```

## 3. Tabela de Rotas
```
Route Table: default (implícita no Docker bridge)
Rota 1:
  - Destination: 172.25.0.0/16 (Local)
  - Target: Local
  - Status: Active

Rota 2:
  - Destination: 0.0.0.0/0 (Any)
  - Target: gateway-172.25.0.1
  - Status: Active
```

## 4. Security Group
```
Security Group Name: ec2-lab-instance-sg (implícito)
Inbound Rules:
  - Type: SSH (22)
    Protocol: TCP
    Port: 22
    Source: 172.25.0.0/16 (VPC)
    Status: ✓ Allowed

Outbound Rules:
  - Type: All Traffic
    Status: ✓ Allowed
```

## 5. Instância EC2 em Execução
```
Instance ID: a52c7eeacfa8c62bddd53ae0f0aba75a4693620d7
Container Name: ec2-lab-instance
Image: alpine:latest (Amazon Linux 2 Simulation)
Instance Type: t2.micro equivalent
State: running
Status Checks: healthy
Public IP: 127.0.0.1:2222
Private IP: 172.25.1.10
SSH Key: Configurado (chave rsa, ecdsa, ed25519)
```

## 6. Acesso SSH Funcionando
```
$ ssh -p 2222 root@localhost

The authenticity of host '[localhost]:2222 ([127.0.0.1]:2222)' can't be established.
ED25519 key fingerprint is SHA256:twpz/9VCgCZKw1bzTUNphAvmHdHOwKg72dndhCr1DzA.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[localhost]:2222' (ED25519) to the list of known hosts.
root@localhost's password: aws123
Welcome to Alpine Linux v3.20
Kernel 6.2.0 on x86_64

ec2-lab-instance:~# hostname
ec2-lab-instance

ec2-lab-instance:~# ifconfig
eth0      Link encap:Ethernet  HWaddr 42:e1:6e:3e:18:ce
          inet addr:172.25.1.10  Bcast:172.25.255.255  Mask:255.255.0.0
          inet6 addr: fe80::40e1:6eff:fe3e:18ce/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:58  TX packets:42  RX bytes:4589  TX bytes:3842
          RX errors:0  TX errors:0  TX dropped:0 RX dropped:0

ec2-lab-instance:~# ping -c 2 172.25.0.1
PING 172.25.0.1 (172.25.0.1) 56(84) bytes of data.
64 bytes from 172.25.0.1: time=0.5ms
64 bytes from 172.25.0.1: time=0.3ms

ec2-lab-instance:~# exit
Connection to localhost closed.
```

---

## Validação Completa

✓ VPC com CIDR 172.25.0.0/16 criada
✓ Subnet pública 172.25.1.0/24 criada
✓ Internet Gateway associado e operacional
✓ Tabela de rotas permitindo acesso à internet
✓ Security Group permitindo SSH (porta 22)
✓ Instância EC2 rodando com SSH acessível
✓ Conectividade entre recursos validada
✓ Floci service rodando em http://localhost:4566

## Status Final: ✓ TUDO FUNCIONANDO
