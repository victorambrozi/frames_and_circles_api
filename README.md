# README

Modelagem do Banco e Regras
- [X] Criar models:
   Frame (quadro): x, y, width, height
   Circle (círculo): x, y, diameter, frame_id

- [x] Adicionar associações:
   Frame -> has_many :circles
   Circle -> belongs_to :frame

-[x] Alterar tipo das colunas e rodar as migrations.

CHECAR Validações e Regras de Negócio
  Criar validações de geometria:
   - [x] Criar testes das validações com model specs.
   - [x] Círculo dentro do quadro
   - [x] Círculo não pode tocar outro no mesmo quadro
   - [x] Quadro não pode tocar outro quadro
