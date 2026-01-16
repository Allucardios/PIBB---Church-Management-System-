# Manual do Utilizador - PIBB Management System v1.0.1
**Data:** 16 de Janeiro de 2026

## Introdução
Bem-vindo à versão 1.0.1 do Sistema de Gestão Financeira da PIBB. Esta aplicação foi desenhada para facilitar o controlo de receitas e despesas da igreja, garantindo transparência e integridade nos dados.

## Funcionalidades Gerais

### 1. Dashboard (Painel Principal)
- **Visão Anual:** Ao entrar na aplicação, verá o resumo do ano corrente.
- **Gráficos:** Evolução de receitas vs despesas e distribuição por categorias.
- **Navegação:** Use o menu lateral (Drawer) para navegar entre módulos.

### 2. Gestão de Receitas e Despesas
- **Listagem Mensal:** As listas abrem agora filtradas pelo mês e ano escolhidos.
- **Filtro de Data:** Utilize o ícone de calendário no topo para mudar o mês visível.
- **Adicionar Novo:** Use o botão "+" (Canto inferior direito) para registar novos movimentos.
- **Actualização:** Arraste a lista para baixo para forçar uma actualização dos dados caso a internet falhe.

### 3. Integração Financeira
- **Contas Bancárias:** As receitas entram automaticamente na conta "Caixa" (ou outra seleccionada).
- **Saldo Real:** Eliminar ou editar uma receita actualiza automaticamente o saldo da conta associada.

## Funcionalidades por Nível de Acesso

### Nível: Básico (Membros/Observadores)
- Acesso de leitura ao Dashboard e Listas (se permitido).
- Visualização do Próprio Perfil.

### Nível: Manager (Tesouraria)
- **Criar/Editar Transacções:** Autonomia total para lançar Entradas e Saídas.
- **Gestão de Contas:** Pode criar contas bancárias e ajustar saldos iniciais.
- **Relatórios:** Acesso à geração de PDFs de Balancetes.

### Nível: Admin (Administrador do Sistema)
- **Gestão de Utilizadores:** Pode criar contas para novos tesoureiros, inactivar membros antigos e redefinir senhas.
- **Gestão de Categorias:** Pode criar novas categorias de despesas (ex: "Obras", "Evangelismo").
- **Acesso Total:** Visibilidade sobre todos os registos e configurações.

## Ciclo de Vida e Actualizações
Esta versão (v1.0.1) marca o início do **Período de Testes Piloto** com a duração prevista de 3 meses.
- **Formato da Versão:** `MAJOR.MINOR.PATCH` (ex: 1.0.1).
- **Actualizações Menores (Patches):** Durante este período, poderão ser lançadas correcções rápidas (ex: 1.0.1+2, 1.0.1+3) para resolver bugs ou erros ortográficos sem interromper o serviço.
- **Versão Final:** Após a conclusão dos testes e validação de todas as funcionalidades, será lançada a versão estável 1.1.0.

## Produção e Suporte
- **Stack Tecnológico:** Flutter (App), Supabase (Backend), PostgreSQL (DB).
- **Suporte:** Em caso de bugs críticos ou dúvidas, contactar a equipa de desenvolvimento.

---
© 2026 PIBB System. Documento confidencial para uso interno.
