#!/bin/bash

if ! command -v docker &>/dev/null; then
  echo "🐳 Docker não encontrado. Instalando Docker..."

  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
  echo "✅ Docker instalado com sucesso."
else
  echo "✅ Docker já está instalado."
fi

echo "🔧 Ativando Docker no boot..."
sudo systemctl enable docker

echo "🔍 Verificando Docker Compose..."
if ! docker compose version &> /dev/null; then
  echo "📦 Docker Compose v2 não encontrado. Instalando plugin..."

  mkdir -p ~/.docker/cli-plugins/
  curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
    -o ~/.docker/cli-plugins/docker-compose
  chmod +x ~/.docker/cli-plugins/docker-compose
  echo "✅ Docker Compose v2 instalado em ~/.docker/cli-plugins/"
else
  echo "✅ Docker Compose v2 já está instalado."
fi

