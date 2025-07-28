#!/bin/bash
set -e

if [ "$1" = "setup" ]; then
  echo "Criando .env a partir do .env.sample se não existir..."
  if [ ! -f .env ]; then
    cp .env.sample .env
  fi

  echo "Subindo containers..."
  docker compose up -d --build

  echo "Rodando migrations..."
  docker compose exec web bin/rails db:create db:migrate

  echo "Setup completo!"

elif [ "$1" = "start" ]; then
  echo "Subindo containers..."
  docker compose up -d

elif [ "$1" = "stop" ]; then
  echo "Parando containers..."
  docker compose down

elif [ "$1" = "unmount" ]; then
  echo "Removendo containers, volumes e arquivos temporários..."
  docker compose down --volumes --remove-orphans
  docker system prune -f
  docker volume prune -f

  echo "Removendo .env e diretórios temporários..."
  rm -f .env
  rm -rf tmp/*

  echo "Ambiente desmontado com sucesso."

else
  echo "Uso: ./execute.sh {setup|start|stop|unmount}"
fi