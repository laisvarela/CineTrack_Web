# CineTrack

## 1) Problema
Após assistir um filme, sempre fica um sentimento bom ou ruim. Pensamentos como "esse filme é a coisa mais xexelenta que já vi" ou "melhor coisa que já me aconteceu foi assistir esse filme", de qualquer forma, é preciso ter um local para expressar e compartilhar essa experiência.
No início, o foco será usuários online com o objetivo de disponibilizar um espaço (site) para avaliação de filmes, incluindo nota e comentários. 

## 2) Atores e Decisores (quem usa / quem decide)
**Usuários principais**: Usuários online
**Decisores/Apoiadores**: Adm

## 3) Casos de uso (de forma simples)
**Todos**: Logar/deslogar, configuração conta, CRUD `avaliacao`
**Usuário**: CRUD `user` (inserir, editar, remover), CRUD `movies` (listar), CRUD `rating` (inserir, listar, editar, remover)
**Adm**: CRUD de `movies` (inserir, listar, editar, remover), CRUD de `rating` (listar, remover)

## 4) Limites e suposições
<!-- Simples assim:
- Limites = regras/prazos/obrigações que você não controla.
- Suposições = coisas que você espera ter e podem falhar.
- Plano B = como você segue com a 1ª fatia se algo falhar.
EXEMPLO:
Limites: entrega final até o fim da disciplina (ex.: 2025-11-30); rodar no
navegador; sem serviços pagos.
Suposições: internet no laboratório; navegador atualizado; acesso ao GitHub; 10
min para teste rápido.
Plano B: sem internet → rodar local e salvar em arquivo/LocalStorage; sem tempo do
professor → testar com 3 colegas. -->
**Limites**: entrega ginal até o fim da disciplina (12/25), rodar no navegador, sem serviços pagos.
**Suposições**: internet no laboratório; navegador atualizado; acesso ao GitHub; 10
min para teste rápido.
**Plano B**: customizar o código com o que está funcionando

## 5) Hipóteses + validação
<!-- Preencha as duas frases abaixo. Simples e direto.
EXEMPLO Valor: Se o aluno ver sua posição na fila, sente mais controle e conclui
melhor a atividade.
Validação: teste com 5 alunos; sucesso se ≥4 abrem/fecham chamado sem ajuda.
EXEMPLO Viabilidade: Com app no navegador (HTML/CSS/JS + armazenamento local),
criar e listar chamados responde em até 1 segundo na maioria das vezes (ex.: 9 de
cada 10).
Validação: medir no protótipo com 30 ações; meta: pelo menos 27 de 30 ações (9/10)
em 1s ou menos. -->
**H-Valor**: Se usuário tem um espaço para opinar, se sente mais confortável em se expressar e melhora o humor.
**Validação** (`rating`): teste com 5 usuários; sucesso se ≥4 avaliam com comentários e nota; falha se ≥4 avaliam com apenas nota; alvo: rating com nota e comentário.
**H-Viabilidade**: Com app no navegador (flutter), criar e responder requisições sem disparar erros.
**Validação** (`no_error`): medir no protótipo com 10 ações; meta: mínimo de erros disparados.

## 6) Fluxo principal e primeira fatia
<!-- Pense “Entrada → Processo → Saída”.
EXEMPLO de Fluxo:
1) Aluno faz login
2) Clica em "Pedir ajuda" e descreve a dúvida
3) Sistema salva e coloca na fila
4) Lista mostra ordem e tempo desde criação
5) Professor encerra o chamado
EXEMPLO de 1ª fatia:
Inclui login simples, criar chamado, listar em ordem.
Critérios de aceite (objetivos): criar → aparece na lista com horário; encerrar →
some ou marca "fechado". -->
**Fluxo principal (curto):**
1) Usuário faz login 
2) Acessa a Home Page
3) Procura/seleciona filme
4) Clica em "Avaliar"
5) Escreve comentário (opcional) e seleciona nota
6) Clica em "Enviar"
   
**Primeira fatia vertical (escopo mínimo):**
Inclui: login, valida dados no Firebase, retorna mensagem de erro ou entra no site, carrega lista de filmes.
Critérios de aceite:
- Sucesso ao validar dados

## 7) Esboços de algumas telas (wireframes)
<img width="1283" height="677" alt="image" src="https://github.com/user-attachments/assets/ac10140f-dc90-423c-8f32-27cd57b257bd" />
<img width="1227" height="569" alt="image" src="https://github.com/user-attachments/assets/c9daf5b8-2421-4047-b244-255ee0f1c04a" />
<img width="950" height="581" alt="image" src="https://github.com/user-attachments/assets/270d9aa0-8b57-427d-8f58-e65a9d26dcd4" />
<img width="886" height="547" alt="image" src="https://github.com/user-attachments/assets/02e084b3-43b0-4855-a661-2a8691f3fc24" />
<img width="747" height="599" alt="image" src="https://github.com/user-attachments/assets/dcd7a865-366f-4d40-b640-e6dc15055576" />
<img width="640" height="598" alt="image" src="https://github.com/user-attachments/assets/a73085c3-3129-4625-bd26-1f99b1403c4b" />
<img width="650" height="433" alt="image" src="https://github.com/user-attachments/assets/83622c10-1c30-400b-b30e-bae14fe37ec1" />



## 8) Tecnologias
<!-- Liste apenas o que você REALMENTE pretende usar agora. -->
### 8.1 Navegador
**Navegador:** [HTML/CSS/JS | React/Vue/Bootstrap/etc., se houver]
**Armazenamento local (se usar):** [LocalStorage/IndexedDB/—]
**Hospedagem:** [GitHub Pages/—]
### 8.2 Front-end (servidor de aplicação, se existir)
**Front-end (servidor):** [ex.: Next.js/React/—]
**Hospedagem:** [ex.: Vercel/—]
### 8.3 Back-end (API/servidor, se existir)
**Back-end (API):** [ex.: FastAPI/Express/PHP/Laravel/Spring/—]
**Banco de dados:** [ex.: SQLite/Postgres/MySQL/MongoDB/—]
**Deploy do back-end:** [ex.: Render/Railway/—]
## 9) Plano de Dados (Dia 0) — somente itens 1–3
<!-- Defina só o essencial para criar o banco depois. -->
### 9.1 Entidades
<!-- EXEMPLO:
- Usuario — pessoa que usa o sistema (aluno/professor)
- Chamado — pedido de ajuda criado por um usuário -->
- [Entidade 1] — [o que representa em 1 linha]
- [Entidade 2] — [...]
- [Entidade 3] — [...]
### 9.2 Campos por entidade
<!-- Use tipos simples: uuid, texto, número, data/hora, booleano, char. -->
### Usuario
| Campo | Tipo | Obrigatório | Exemplo |
|-----------------|-------------------------------|-------------|--------------------|
| id | número | sim | 1 |
| nome | texto | sim | "Ana Souza" |
| email | texto | sim (único) | "ana@exemplo.com" |
| senha_hash | texto | sim | "$2a$10$..." |
| papel | número (0=aluno, 1=professor) | sim | 0 |
| dataCriacao | data/hora | sim | 2025-08-20 14:30 |
| dataAtualizacao | data/hora | sim | 2025-08-20 15:10 |
### Chamado
| Campo | Tipo | Obrigatório | Exemplo |
|-----------------|--------------------|-------------|-------------------------|
| id | número | sim | 2 |
| Usuario_id | número (fk) | sim | 8f3a-... |
| texto | texto | sim | "Erro ao compilar" |
| estado | char | sim | 'a' \| 'f' |
| dataCriacao | data/hora | sim | 2025-08-20 14:35 |
| dataAtualizacao | data/hora | sim | 2025-08-20 14:50 |
### 9.3 Relações entre entidades
<!-- Frases simples bastam. EXEMPLO:
Um Usuario tem muitos Chamados (1→N).
Um Chamado pertence a um Usuario (N→1). -->
- Um [A] tem muitos [B]. (1→N)
- Um [B] pertence a um [A]. (N→1)
