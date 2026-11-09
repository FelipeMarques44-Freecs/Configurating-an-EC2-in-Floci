#!/bin/sh

# Instala OpenSSH server
apk add --no-cache openssh openssh-server openssh-client bash curl

# Cria diretório SSH
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Gera chaves SSH
ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -t ecdsa -N "" -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key

# Configura SSH
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "root:aws123" | chpasswd

# Inicia SSH server
/usr/sbin/sshd -D
