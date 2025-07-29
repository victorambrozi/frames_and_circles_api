# README - API de Frames e Círculos

Esta API permite gerenciar frames (quadros) e círculos, com validações para garantir que os círculos permaneçam dentro de seus quadros e não se sobreponham.

## Dependências
 - [Instalação do Docker](!https://docs.docker.com/engine/install/)
 - [Instalação do plugin docker-compose](!https://docs.docker.com/compose/install/)

## Configuração Inicial

### 1. Clone o repositório
```
  $ git clone git@github.com:victorambrozi/frames_and_circles_api.git
  $ cd frames_and_circles_api
```
### 2. Inicie o Docker
### 3. Realize o setup da aplicação utilizando o comando
Utilize o script execute.sh para facilitar a configuração:
```
  $ sh execute.sh setup   # Configura o ambiente inicial
```
Este comando irá:
  - Criar um arquivo .env baseado no .env.sample;
  - Construir e subir os containers Docker;
  - Executar as migrations do banco de dados.

### Comandos Úteis:

| Comando               | Descrição                                                                 |
|-----------------------|---------------------------------------------------------------------------|
| `./execute.sh setup`  | Configura o ambiente inicial (cria .env, builda containers, roda migrations) |
| `./execute.sh start`  | Inicia os containers Docker                                              |
| `./execute.sh stop`   | Para os containers sem remover volumes                                   |
| `./execute.sh unmount`| Remove completamente o ambiente (containers, volumes e arquivos temporários) |
| `./execute.sh test`   | Executa os testes RSpec                                                  |
| `./execute.sh test-doc` | Executa testes e gera/atualiza documentação Swagger                    |

### 4. Inicie a aplicação utilizando o comando:
```
$ sh execute.sh start
```

## Acessando a API
A API estará disponível em:
- `http://localhost:3000`
- Documentação Swagger UI: `http://localhost:3000/api-docs`

## Endpoints Principais
### Frames
- `POST /frames` - Cria um novo frame
- `GET /frames/:id` - Retorna um frame específico com métricas
- `DELETE /frames/:id` - Remove um frame (se não tiver círculos associados)

### Círculos
- `POST /frames/:frame_id/circles` - Cria um círculo dentro de um frame
- `PUT /circles/:id` - Atualiza um círculo
- `DELETE /circles/:id` - Remove um círculo
- `GET /circles - Busca` círculos (com filtros por frame ou área circular)

## Estrutura do Projeto
```
├── app/                 # Código principal da aplicação
│   ├── controllers/     # Controllers da API
│   ├── models/          # Modelos do ActiveRecord
│   └── ...
├── config/              # Configurações do Rails
├── db/                  # Migrations e schema do banco de dados
├── spec/                # Testes
│   ├── integration/     # Testes de integração
│   ├── swagger/         # Especificações Swagger
│   └── ...
├── docker-compose.yml   # Configuração do Docker Compose
├── Dockerfile           # Configuração do container principal
├── .env.sample          # Variáveis de ambiente de exemplo
└── execute.sh           # Script para facilitar a execução
```

## Testando a API
Para executar os testes e gerar a documentação Swagger:
```
$ sh execute.sh test-doc
```
Isso irá:
- Executar todos os testes RSpec;
- Gerar/atualizar a documentação Swagger baseada nos testes;
- A documentação estará disponível em `http://localhost:3000/api-docs`

## Outros Comandos Úteis
- Parar a aplicação:
  ```
  $ sh execute.sh stop
  ```
  **IMPORTANTE**: Se você parou a aplicação e deseja rodar novamente, apenas execute o comando para rodar a aplicação, não é necessário criar novamente.

- Para remover completamente todos os containers, volumes e arquivos temporários:
  ```
    $ sh execute.sh unmount
    ```
    **IMPORTANTE**: Se você desmontar os containeres da aplicação, será necessário rodar o comando `setup` novamente caso deseje voltar a executá-la.