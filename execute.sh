#!/bin/bash
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

case "$1" in
  "setup")
    echo - "${GREEN}Criando .env a partir do .env.sample se não existir...${NC}"
    if [ ! -f .env ]; then
      cp .env.sample .env
    fi

    echo - "${GREEN}Subindo containers...${NC}"
    docker compose up -d --build

    echo - "${GREEN}Rodando migrations...${NC}"
    docker compose exec web bin/rails db:create db:migrate

    echo - "${GREEN}Setup completo!${NC}"
    ;;

  "start")
    echo - "${GREEN}Subindo containers...${NC}"
    docker compose up -d
    ;;

  "stop")
    echo - "${GREEN}Parando containers...${NC}"
    docker compose down
    ;;

  "unmount")
    echo - "${GREEN}Removendo containers, volumes e arquivos temporários...${NC}"
    docker compose down --volumes --remove-orphans
    docker system prune -f
    docker volume prune -f

    echo - "${GREEN}Removendo .env e diretórios temporários...${NC}"
    rm -f .env
    rm -rf tmp/*

    echo - "${GREEN}Ambiente desmontado com sucesso.${NC}"
    ;;

  "test")
    echo - "${GREEN}Executando testes...${NC}"
    docker compose exec web bundle exec rspec
    
    echo - "${GREEN}Gerando documentação Swagger...${NC}"
    docker compose exec web rails rswag:specs:swaggerize
    ;;

  "test-doc")
    echo - "${GREEN}Executando testes e gerando documentação...${NC}"
    docker compose exec web bundle exec rspec --format documentation
    docker compose exec web rails rswag:specs:swaggerize
    ;;

  *)
    echo - "${BLUE}Uso: ./execute.sh {comando}${NC}"
    echo - "${BLUE}Comandos disponíveis:${NC}"
    echo - "${BLUE}  setup     - Configura o ambiente inicial${NC}"
    echo - "${BLUE}  start     - Inicia os containers${NC}"
    echo - "${BLUE}  stop      - Para os containers${NC}"
    echo - "${BLUE}  unmount   - Remove completamente o ambiente${NC}"
    echo - "${BLUE}  test      - Executa os testes${NC}"
    echo - "${BLUE}  test-doc  - Executa testes e gera documentação${NC}"
    ;;
esac