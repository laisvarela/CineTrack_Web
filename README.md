# 🎬 CineTrack_Web
CineTrack_Web é um projeto acadêmico desenvolvido para a disciplina de Desenvolvimento Web. O objetivo é criar uma plataforma interativa de avaliação de filmes, incorporando desde fundamentos básicos da web até práticas avançadas de segurança e integração de tecnologias modernas.

# 🚀 Visão Geral
Este site permite que usuários explorem, avaliem e gerenciem filmes, com funcionalidades completas de CRUD e scraping automatizado para popular dados. Além disso, o projeto implementa medidas robustas de segurança, como proteção contra CSRF via tokens e cookies seguros com atributos HttpOnly e SameSite.

# 🛠️ Tecnologias Utilizadas
- **Laravel** - Backend e gerenciamento de rotas 
- **Blade** - Sistema de templates para renderização de views no Laravel
- **PHP** - Lógica de servidor
- **HTML & CSS** - Estrutura e estilo da aplicação 
- **PostgreSQL** - Banco de dados relacional
- **Python** - Web scraping para popular filmes e gêneros 

# 📌 Funcionalidades Principais
- 👤 CRUD de Usuários: Cadastro, edição, visualização e exclusão de contas
- 🎞️ CRUD de Filmes: Gerenciamento completo de títulos e informações
- 🧠 Scraping Automatizado: População da base de dados com filmes e gêneros extraídos de fontes externas
- ⭐ Sistema de Avaliação: Usuários podem avaliar filmes e visualizar médias

# 🔐 Segurança
O projeto aplica boas práticas de segurança para proteger dados e sessões:
- Tokens `CSRF` para prevenir ataques de falsificação de requisições
- Cookies configurados com `HttpOnly` e `SameSite` para evitar acesso indevido e vazamento de sessão
