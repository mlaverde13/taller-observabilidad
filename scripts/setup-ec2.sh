#!/usr/bin/env bash
# Prepara una instancia EC2 Ubuntu 22.04/24.04: instala Docker + Compose y clona el repo.
# Uso: bash setup-ec2.sh https://github.com/USUARIO/taller-observabilidad.git
set -e
REPO_URL="$1"

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl git
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"

cd ~
git clone "$REPO_URL"
echo "Listo. Cierre la sesión SSH y vuelva a entrar para usar docker sin sudo."
