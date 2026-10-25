> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro**. Editar no repo `space-cursor-skills/docs/`; destino Cursor/Claude Code é cópia (`npm run sync`).

# Banco de dados — modelagem, dinheiro, datas e migrations

Isto **é** padrão (vale para todo projeto), não sugestão. Nomes de tabela, coluna, usuário e o banco da empresa (PostgreSQL) estão em [nomenclatura.md](nomenclatura.md) e AP-NAM-05. Camadas e queries (ORM, N+1, SQL concatenado) em [anti-padroes.md](anti-padroes.md) §C. Promoção de código e deploy em [git-fluxo.md](git-fluxo.md).

Cada regra tem um ID (`BD-xx`) para citar na task e no PR. Cada uma é **inviolável** até o PO escrever o contrário **por escrito na task**, ou as regras do projeto registrarem a exceção com o motivo.

Origem: correções do dono num projeto real com vários fornecedores externos e um banco por cliente (outubro de 2026), generalizadas em 2026-10-24.

Como cada skill usa este arquivo: [README.md](README.md).

---

## Modelagem

### BD-01 — Dinheiro é inteiro, em centavos, e a coluna diz isso

- Valor em dinheiro no banco é **inteiro, em centavos**: `bigint` no PostgreSQL (inteiro no MySQL). Nunca `numeric`/`decimal`/`float`.
- O nome da coluna **termina em `Cents`** (`amountCents`, `balanceAfterCents`), para ninguém ler como reais.
- O que chega em reais de fora (gateway, fornecedor) é convertido **na entrada**, **a partir do texto** (`"12.34"` → `1234`), sem passar por `float`: `0.1 + 0.2` em ponto flutuante não é `0.3`, e um centavo perdido por transação vira diferença no fechamento.
- A conversão para reais é só na hora de mostrar (formatador único do projeto).

### BD-02 — Data e hora no banco são sempre UTC

- O app grava e lê em **UTC** (fuso da aplicação = `UTC`, conexão do banco em `+00:00`). Nunca no fuso local de quem usa (ex.: `America/Sao_Paulo`, UTC-3).
- A conversão para o fuso de quem vê é feita **no código, na hora de mostrar** (tela, CSV, relatório).
- Filtro de período converte o dia local para UTC **antes** de consultar (o "dia 24" em São Paulo vai de `24T03:00Z` a `25T02:59:59Z`).
- Data que vem de fora (gateway, fornecedor) é convertida para UTC na entrada.
- Data trocada entre sistemas vai em ISO 8601 **com o fuso** (`2026-10-22T03:58:00Z`).
- Ao restaurar um dump, conferir que as datas não foram deslocadas (opção de manter UTC do dump e `SET time_zone='+00:00'`).

### BD-03 — Id que vem de fora é sempre texto

- Id vindo de gateway ou serviço externo é guardado e comparado como **texto**.
- Na entrada, aceitar número **ou** texto e converter (`String(valor)`, `z.coerce.string()`). Nunca exigir só `string` nem descartar o número.
- Motivo (caso real): um gateway alternava o formato (`4080` × `"4080"`, id numérico × UUID) e cada mudança travou saques.

### BD-04 — Todo id ou código de fora começa com `external`

- Coluna ou campo que guarda identificador de outro sistema: `external` + o que é, em camelCase: `externalCode`, `externalRoundId`, `externalEventId`, `externalSessionId`.
- Proibido nome que não diz o que é: `eventKey`, `gameCode`, `kind`, `code` solto.

### BD-05 — Fornecedor é cadastro; o que é dele vai em `jsonb`

- Fornecedor (gateway, agregador, provedor de KYC…) é **uma linha de uma tabela de cadastro**, não um `enum` no código nem uma coluna por fornecedor. O código usa o `code` da linha para escolher o adaptador (dicionário — [padrao-ouro.md](padrao-ouro.md) GO-13).
- O que é **próprio de um fornecedor** (credenciais, configuração, campos que um tem e outro não) vai numa coluna **`jsonb`** (PostgreSQL; `json` no MySQL), nunca em coluna fixa. Exemplo: um fornecedor usa `clientId` + `clientSecret`; outro usa `apiKey` — os dois cabem na mesma coluna.
- O valor da credencial **nunca** vai para o git nem para `docs/` (GO-09): o `jsonb` é preenchido no ambiente.

### BD-06 — Referência interna é FK para o nosso id

- Tabelas apontam umas para as outras pelo **nosso id** (`productId` → `products.id`), nunca pelo código externo.
- O código externo (`externalCode`) mora numa tabela só: a **dona** dele. Se o fornecedor troca o código, atualiza-se um lugar só (GO-04).

### BD-07 — Pessoa liga pelo id, nunca por dado de contato

- Usuário, cliente, afiliado: ligar sempre pelo **id** (`userId`, `inviterId`, `affiliateId`). E-mail, telefone e documento são **dado de contato**, não chave.
- Tabela nova que guarda pessoa grava o id; leitura nova liga pelo id.
- Motivo (caso real): tabelas de dinheiro ligadas por e-mail, com colação diferente da tabela de usuários, não usavam índice; e trocar o e-mail desligaria o histórico.

### BD-08 — Salvar nunca deixa dado pela metade

- Troca de vários registros (apagar e regravar uma lista, reordenar, salvar um formulário com filhos) roda **dentro de uma transação**.
- Nada de `truncate` (ou `delete` geral) antes do `insert` fora da transação: se o insert falha, a lista some.

---

## Migrations

### BD-09 — Migration vai com o código e é o único jeito de mudar dado

- A migration da coluna vai **no mesmo PR** do código que usa a coluna ([git-fluxo.md](git-fluxo.md)). O deploy roda as migrations sozinho; nada roda à mão.
- **Toda mudança de dado** (correção, preenchimento de coluna nova, limpeza) é **migration**, nunca comando direto no banco nem console do framework. Motivo: o mesmo código roda em vários bancos (um por cliente/casa) e só a migration chega a todos.
- A migration de dado é:
  - **genérica:** a regra que vale para qualquer cliente; nada de id fixo de um banco só;
  - **idempotente:** rodar duas vezes dá o mesmo resultado (conferir se a tabela/coluna existe antes de criar ou apagar; `WHERE` que só pega o que falta);
  - **testada numa cópia** do banco antes do PR.
- Leitura direta no banco para conferir pode.

### BD-10 — Banco compartilhado entre repositórios

Quando dois ou mais repositórios (ex.: site e painel) usam o **mesmo banco** e a mesma tabela de controle de migrations:

- **Cada repo tem as migrations das colunas e tabelas que o próprio código usa.** A ordem de deploy é livre e um repo pode subir sozinho.
- Migration que os dois usam vai para os dois com o **mesmo nome de arquivo e o mesmo conteúdo**. Roda uma vez, no repo que subir primeiro; o outro vê que já rodou e pula.
- A migration **não usa classes do app** (models, services): usa o construtor de consultas do banco, para rodar igual nos dois repos.
- Antes de entregar: conferir que a migration está em todos os repos que usam a coluna.

### BD-11 — Migrations rodam com trava

- Se mais de um serviço migra o mesmo banco no deploy, o comando de migrate pega uma **trava no banco** (lock nomeado, com espera) antes de rodar. Sem trava, dois serviços subindo juntos rodam a mesma migration duas vezes ("Duplicate column"; caso real 2026-10-23).
- O comando com trava é **idêntico** em todos os repos que migram o banco, e o *entrypoint* do container usa ele, nunca o migrate puro.

### BD-12 — Colação e encoding iguais em quem faz JOIN

- Coluna de tabela nova que entra em JOIN com tabela antiga usa a **mesma colação/encoding** da antiga, senão o banco recusa ("Illegal mix of collations") ou ignora o índice.
- Teste com outro banco (ex.: SQLite em memória) não pega isso: conferir no banco real do ambiente de desenvolvimento.

---

## Cache

### BD-13 — Mudou o formato do que está em cache, sobe a versão da chave

- Se o conteúdo guardado numa chave de cache muda de formato (campo novo, texto formatado diferente), a chave ganha versão nova (`catalog_v3` → `catalog_v4`) no mesmo PR, em todos os lugares que leem e gravam a chave.
- Sem isso, o código novo lê o formato velho até o cache expirar.
- Se só o filtro muda e o formato não, a chave fica.

---

## Checklist de PR — Banco (colar)

- [ ] Dinheiro em inteiro de centavos, coluna `…Cents`, conversão a partir do texto (BD-01)
- [ ] Data gravada em UTC; conversão só na exibição; filtro de período convertido (BD-02)
- [ ] Id externo como texto, aceitando número; nome `external…` (BD-03, BD-04)
- [ ] Fornecedor por cadastro; específico dele em `jsonb`; sem credencial no git (BD-05)
- [ ] Referências pelo nosso id; pessoa pelo id, não por e-mail (BD-06, BD-07)
- [ ] Salvar em transação, sem truncate antes do insert (BD-08)
- [ ] Migration no mesmo PR, genérica, idempotente, testada numa cópia; dado só por migration (BD-09)
- [ ] Banco compartilhado: migration em todos os repos que usam a coluna, mesmo nome e conteúdo, sem classe do app (BD-10)
- [ ] Migrate do deploy com trava (BD-11)
- [ ] Colação igual em coluna que entra em JOIN, conferida no banco real (BD-12)
- [ ] Chave de cache com versão nova se o formato mudou (BD-13)
- [ ] PR avisa que a migration roda sozinha no deploy
