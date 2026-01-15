# 🔍 Análise Completa - Arquivos com GetX

## 📊 Resumo
- **Total de arquivos com GetX**: 30 arquivos
- **Prioridade**: Migrar da camada mais baixa para a mais alta

## 📁 Arquivos por Categoria

### 🔴 ALTA PRIORIDADE - Core & Widgets (4 arquivos)
1. ✅ `lib/core/widgets/auth_gate.dart` - **JÁ MIGRADO**
2. ⏳ `lib/core/widgets/email_tf.dart` - Widget de email
3. ⏳ `lib/core/const/functions.dart` - Funções utilitárias

### 🟠 MÉDIA PRIORIDADE - Controllers (5 arquivos - DEPRECATED)
Estes arquivos serão **DELETADOS** após migração completa:
1. `lib/data/controllers/auth.dart`
2. `lib/data/controllers/profile.dart`
3. `lib/data/controllers/finance.dart`
4. `lib/data/controllers/category.dart`
5. `lib/data/controllers/connect.dart`
6. `lib/data/service/bindings.dart`

### 🟡 MÉDIA-ALTA PRIORIDADE - Auth (3 arquivos)
1. ⏳ `lib/ui/auth/sign_in.dart` - Login
2. ⏳ `lib/ui/auth/sign_up.dart` - Registro
3. ⏳ `lib/ui/auth/forgot_pass.dart` - Recuperar senha

### 🟢 MÉDIA PRIORIDADE - Home (8 arquivos)
1. ⏳ `lib/ui/home/home.dart` - Página principal
2. ⏳ `lib/ui/home/dashboard.dart` - Dashboard (6 Obx)
3. ⏳ `lib/ui/home/income.dart` - Lista de receitas
4. ⏳ `lib/ui/home/expenses.dart` - Lista de despesas
5. ⏳ `lib/ui/home/categories.dart` - Categorias
6. ⏳ `lib/ui/home/users.dart` - Usuários
7. ⏳ `lib/ui/home/profile.dart` - Perfil
8. ⏳ `lib/ui/home/report.dart` - Relatórios

### 🔵 BAIXA PRIORIDADE - Forms (3 arquivos)
1. ⏳ `lib/ui/form/income.dart` - Formulário de receita
2. ⏳ `lib/ui/form/expense.dart` - Formulário de despesa (1 Obx)
3. ⏳ `lib/ui/form/profile.dart` - Formulário de perfil

### 🟣 BAIXA PRIORIDADE - Cards (3 arquivos)
1. ⏳ `lib/ui/card/income.dart` - Card de receita
2. ⏳ `lib/ui/card/expense.dart` - Card de despesa
3. ⏳ `lib/ui/card/category.dart` - Card de categoria

### 🟤 BAIXA PRIORIDADE - Views (3 arquivos)
1. ⏳ `lib/ui/view/drawer.dart` - Menu lateral (4 Get.to)
2. ⏳ `lib/ui/view/income.dart` - Visualização de receita
3. ⏳ `lib/ui/view/expense.dart` - Visualização de despesa

### ⚫ BAIXA PRIORIDADE - Reports (2 arquivos)
1. ✅ `lib/ui/report/month.dart` - **JÁ MIGRADO**
2. ⏳ `lib/ui/report/anual.dart` - Relatório anual
3. ⏳ `lib/ui/report/quaterly.dart` - Relatório trimestral

## 🎯 Plano de Migração

### Fase 1: Core & Utilities ✅ (Em Progresso)
- [x] `auth_gate.dart`
- [ ] `email_tf.dart`
- [ ] `functions.dart`

### Fase 2: Autenticação 🔴 (Crítico)
- [ ] `sign_in.dart`
- [ ] `sign_up.dart`
- [ ] `forgot_pass.dart`

### Fase 3: Home & Dashboard 🟠 (Importante)
- [ ] `home.dart`
- [ ] `dashboard.dart`
- [ ] `income.dart`
- [ ] `expenses.dart`

### Fase 4: Forms & Cards 🟡 (Médio)
- [ ] `form/income.dart`
- [ ] `form/expense.dart`
- [ ] `form/profile.dart`
- [ ] `card/income.dart`
- [ ] `card/expense.dart`
- [ ] `card/category.dart`

### Fase 5: Views & Reports 🟢 (Baixo)
- [ ] `view/drawer.dart`
- [ ] `view/income.dart`
- [ ] `view/expense.dart`
- [ ] `report/anual.dart`
- [ ] `report/quaterly.dart`

### Fase 6: Limpeza Final 🧹
- [ ] Deletar `lib/data/controllers/`
- [ ] Deletar `lib/data/service/bindings.dart`
- [ ] Verificar imports não utilizados
- [ ] Executar testes

## 📝 Padrões de Migração

### GetX → Riverpod

#### 1. Imports
```dart
// ANTES
import 'package:get/get.dart';
import '../../data/controllers/auth.dart';

// DEPOIS
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/auth_provider.dart';
```

#### 2. Widget Base
```dart
// ANTES
class MyWidget extends StatelessWidget {
  final ctrl = Get.find<AuthCtrl>();
  
// DEPOIS
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
```

#### 3. Observação de Estado
```dart
// ANTES
Obx(() => Text(ctrl.value.toString()))

// DEPOIS
Consumer(
  builder: (context, ref, child) {
    final value = ref.watch(provider);
    return Text(value.toString());
  },
)
```

#### 4. Navegação
```dart
// ANTES
Get.to(() => NextPage())
Get.back()

// DEPOIS
Navigator.of(context).push(MaterialPageRoute(builder: (_) => NextPage()))
Navigator.of(context).pop()
```

## 🚀 Início da Migração Automática

Vou começar a migrar os arquivos na ordem de prioridade...
