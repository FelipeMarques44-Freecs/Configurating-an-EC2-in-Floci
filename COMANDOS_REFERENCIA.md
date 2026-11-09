# Guia de Comandos - Infraestrutura AWS Simulada

## Iniciar o Ambiente

```bash
# Subir todos os containers
docker compose up -d

# Verificar status
docker ps
```

## Verificar Recursos

### VPC e Network
```bash
# Inspecionar a rede VPC
docker network inspect default_vpc_network

# Listar todas as redes
docker network ls
```

### Instância EC2

```bash
# Ver status da EC2
docker ps | findstr ec2-lab-instance

# Ver logs da EC2
docker logs ec2-lab-instance

# Entrar no container (sem SSH)
docker exec -it ec2-lab-instance sh

# Ver IP da EC2
docker inspect ec2-lab-instance | findstr IPv4Address
```

### Internet Gateway

```bash
# Verificar se está rodando
docker ps | findstr internet-gateway

# Ver logs do IGW
docker logs internet-gateway
```

### Floci Service

```bash
# Verificar status
docker ps | findstr floci

# Ver logs do Floci
docker logs floci-service

# Testar API do Floci (listar buckets S3)
curl http://localhost:4566/

# Listar buckets (deve estar vazio inicialmente)
curl http://localhost:4566/
```

## Acessar EC2 via SSH

### Opção 1: SSH direto (requer cliente SSH)

```bash
ssh -p 2222 root@localhost
# Senha: aws123
```

### Opção 2: Usar docker exec

```bash
docker exec -it ec2-lab-instance sh
```

### Opção 3: Usar sshpass (se instalado)

```bash
sshpass -p aws123 ssh -o StrictHostKeyChecking=no -p 2222 root@localhost
```

## Testes de Conectividade

### De dentro do EC2

```bash
# Entrar na EC2
docker exec -it ec2-lab-instance sh

# Testar conectividade ao IGW
ping 172.25.0.1

# Testar conectividade ao Floci
curl http://172.25.0.50:4566/

# Ver informações de rede
ifconfig
```

### Do host

```bash
# Testar acesso SSH
ssh -p 2222 root@localhost

# Testar Floci
curl http://localhost:4566/

# Ver todos os containers
docker ps

# Ver rede detalhes
docker network inspect default_vpc_network
```

## Gerenciamento

### Parar o ambiente

```bash
docker compose down
```

### Remover dados (volumes, networks)

```bash
docker compose down -v
```

### Ver recursos completos

```bash
# Todos os containers
docker ps -a

# Todas as redes
docker network ls

# Detalhes da VPC
docker network inspect default_vpc_network

# Detalhes da EC2
docker inspect ec2-lab-instance

# Detalhes do Floci
docker inspect floci-service
```

## Monitoramento

### Logs em tempo real

```bash
# EC2
docker logs -f ec2-lab-instance

# Floci
docker logs -f floci-service

# Todos
docker compose logs -f
```

### Estatísticas de recursos

```bash
# Ver uso de CPU/Memória
docker stats

# Ver disco usado
docker system df
```

## Troubleshooting

### Se SSH não conectar

```bash
# Verificar se porta 2222 está mapeada
docker port ec2-lab-instance

# Verificar se sshd está rodando
docker exec ec2-lab-instance ps aux | grep sshd

# Ver logs para erros
docker logs ec2-lab-instance
```

### Se Floci não responder

```bash
# Verificar status
docker ps | grep floci

# Ver logs
docker logs floci-service

# Testar acesso
curl -v http://localhost:4566/
```

### Se rede não funcionar

```bash
# Inspecionar rede
docker network inspect default_vpc_network

# Verificar IPs dos containers
docker ps --format "{{.Names}}\t{{.Status}}\t{{.Ports}}"

# Reconectar container à rede (se necessário)
docker network connect default_vpc_network ec2-lab-instance
```

## Arquivos Importantes

- **docker-compose.yml**: Definição de toda a infraestrutura
- **entrypoint.sh**: Script de inicialização do EC2
- **RELATORIO_INFRAESTRUTURA.md**: Relatório completo da solução
- **SCREENSHOTS_DOCUMENTACAO.md**: Documentação com screenshots simulados
- **test-infrastructure.bat**: Script de testes (Windows)

## Checklist de Verificação

- [ ] VPC criada (172.25.0.0/16)
- [ ] Subnet pública criada (172.25.1.0/24)
- [ ] Internet Gateway rodando
- [ ] EC2 instance rodando
- [ ] SSH acessível na porta 2222
- [ ] Floci rodando na porta 4566
- [ ] Todas as redes conectadas
- [ ] Testes passando
- [ ] Relatório gerado
