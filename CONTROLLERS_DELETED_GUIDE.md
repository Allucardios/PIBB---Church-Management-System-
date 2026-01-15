# 🗑️ Controllers Deletados - Guia de Atualização

## ✅ O Que Foi Deletado

### Diretório Completo
- ❌ `lib/data/controllers/` - **DELETADO**
  - ❌ `auth.dart`
  - ❌ `profile.dart`
  - ❌ `finance.dart`
  - ❌ `category.dart`
  - ❌ `connect.dart`

### Arquivo de Bindings
- ❌ `lib/data/service/bindings.dart` - **DELETADO**

## 🔄 Tabela de Substituição

| Controller Antigo (DELETADO) | Provider Novo (USAR) |
|------------------------------|----------------------|
| `AuthCtrl` | `authNotifierProvider`, `authServiceProvider` |
| `ProfileCtrl` | `currentProfileProvider`, `profileServiceProvider` |
| `FinanceCtrl` | `incomeStreamProvider`, `expenseStreamProvider`, `financeServiceProvider` |
| `CategoryCtrl` | `categoriesStreamProvider`, `categoryServiceProvider` |
| `ConnectCtrl` | `connectivityStatusProvider` |

## 📝 Como Atualizar Cada Arquivo

### Padrão Geral

#### ANTES (GetX):
```dart
import 'package:get/get.dart';
import '../../data/controllers/finance.dart';

class MyWidget extends StatelessWidget {
  final ctrl = Get.find<FinanceCtrl>();
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text('${ctrl.incomeList.length}'));
  }
}
```

#### DEPOIS (Riverpod):
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/finance_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomesAsync = ref.watch(incomeStreamProvider);
    
    return incomesAsync.when(
      data: (incomes) => Text('${incomes.length}'),
      loading: () => CircularProgressIndicator(),
      error: (error, _) => Text('Erro: $error'),
    );
  }
}
```

## 🎯 Arquivos que Precisam Ser Atualizados

### 🔴 CRÍTICO - Não Compilam (25 arquivos)

Estes arquivos **NÃO VÃO COMPILAR** até serem atualizados:

#### Autenticação (3)
- [ ] `lib/ui/auth/sign_in.dart` - Usa `AuthCtrl`
- [ ] `lib/ui/auth/sign_up.dart` - Usa `AuthCtrl`
- [ ] `lib/ui/auth/forgot_pass.dart` - Usa `AuthCtrl`

#### Home (8)
- [ ] `lib/ui/home/home.dart` - Usa `ProfileCtrl`
- [ ] `lib/ui/home/dashboard.dart` - Usa `FinanceCtrl`
- [ ] `lib/ui/home/income.dart` - Usa `FinanceCtrl`
- [ ] `lib/ui/home/expenses.dart` - Usa `FinanceCtrl`, `ProfileCtrl`
- [ ] `lib/ui/home/categories.dart` - Usa `CategoryCtrl`
- [ ] `lib/ui/home/users.dart` - Usa `ProfileCtrl`
- [ ] `lib/ui/home/profile.dart` - Usa `ProfileCtrl`
- [ ] `lib/ui/home/report.dart` - Usa `FinanceCtrl`

#### Forms (3)
- [ ] `lib/ui/form/income.dart` - Usa `FinanceCtrl`
- [ ] `lib/ui/form/expense.dart` - Usa `FinanceCtrl`, `CategoryCtrl`
- [ ] `lib/ui/form/profile.dart` - Usa `ProfileCtrl`

#### Cards (3)
- [ ] `lib/ui/card/income.dart` - Usa `FinanceCtrl`
- [ ] `lib/ui/card/expense.dart` - Usa `FinanceCtrl`
- [ ] `lib/ui/card/category.dart` - Usa `CategoryCtrl`

#### Views (3)
- [ ] `lib/ui/view/drawer.dart` - Usa `ProfileCtrl`
- [ ] `lib/ui/view/income.dart` - Usa `FinanceCtrl`, `ProfileCtrl`
- [ ] `lib/ui/view/expense.dart` - Usa `FinanceCtrl`

#### Reports (2)
- [ ] `lib/ui/report/anual.dart` - Usa `FinanceCtrl`
- [ ] `lib/ui/report/quaterly.dart` - Usa `FinanceCtrl`

## 🔧 Guia de Substituição por Controller

### 1. AuthCtrl → Providers de Autenticação

```dart
// ANTES
final ctrl = Get.find<AuthCtrl>();
ctrl.signIn(email, password);
final user = ctrl.user;
final isLoading = ctrl.isLoading.value;
final error = ctrl.errorMessage.value;

// DEPOIS
final user = ref.watch(authNotifierProvider);
final isLoading = ref.watch(authLoadingNotifierProvider);
final error = ref.watch(authErrorNotifierProvider);
await ref.read(authServiceProvider.notifier).signIn(email, password, context);
```

### 2. ProfileCtrl → Providers de Perfil

```dart
// ANTES
final ctrl = Get.find<ProfileCtrl>();
final profile = ctrl.profile.value;
final profiles = ctrl.profileList;
ctrl.updateProfile(profile);
ctrl.logout();
final isAdmin = ctrl.isAdmin();

// DEPOIS
final profile = ref.watch(currentProfileProvider);
final profilesAsync = ref.watch(allProfilesProvider);
await ref.read(currentProfileProvider.notifier).updateProfile(profile);
await ref.read(currentProfileProvider.notifier).logout(context);
final isAdmin = ref.read(currentProfileProvider.notifier).isAdmin();
```

### 3. FinanceCtrl → Providers de Finanças

```dart
// ANTES
final ctrl = Get.find<FinanceCtrl>();
final incomes = ctrl.incomeList;
final expenses = ctrl.expenseList;
final monthlyIncome = ctrl.getMonthlyIncome(DateTime.now());
ctrl.addIncome(income);
ctrl.deleteExpense(id);

// DEPOIS
final incomesAsync = ref.watch(incomeStreamProvider);
final expensesAsync = ref.watch(expenseStreamProvider);

// Para cálculos
final calc = ref.read(financeCalculationsProvider.notifier);
final incomes = incomesAsync.value ?? [];
final monthlyIncome = calc.getMonthlyIncome(incomes, DateTime.now());

// Para ações
await ref.read(financeServiceProvider.notifier).addIncome(income);
await ref.read(financeServiceProvider.notifier).deleteExpense(id);
```

### 4. CategoryCtrl → Providers de Categoria

```dart
// ANTES
final ctrl = Get.find<CategoryCtrl>();
final categories = ctrl.categoryList;
ctrl.addCategory(category);
ctrl.deleteCategory(id);

// DEPOIS
final categoriesAsync = ref.watch(categoriesStreamProvider);
await ref.read(categoryServiceProvider.notifier).addCategory(category);
await ref.read(categoryServiceProvider.notifier).deleteCategory(id);
```

### 5. ConnectCtrl → Provider de Conectividade

```dart
// ANTES
final ctrl = Get.find<ConnectCtrl>();
final isConnected = ctrl.isConnected.value;

// DEPOIS
final isConnected = ref.watch(connectivityStatusProvider);
```

## 📋 Checklist de Migração por Arquivo

Para cada arquivo que precisa ser atualizado:

- [ ] Remover `import 'package:get/get.dart'`
- [ ] Adicionar `import 'package:flutter_riverpod/flutter_riverpod.dart'`
- [ ] Remover imports de controllers (`../../data/controllers/...`)
- [ ] Adicionar imports de providers (`../../data/providers/...`)
- [ ] Mudar de `StatelessWidget` para `ConsumerWidget`
- [ ] Mudar de `StatefulWidget` para `ConsumerStatefulWidget`
- [ ] Remover `Get.find<Controller>()`
- [ ] Adicionar `ref.watch(provider)` ou `ref.read(provider)`
- [ ] Substituir `Obx(() => ...)` por `Consumer` ou lógica direta
- [ ] Substituir `Get.to()` por `Navigator.of(context).push()`
- [ ] Substituir `Get.back()` por `Navigator.of(context).pop()`
- [ ] Testar o arquivo

## 🚀 Próximos Passos

### Opção 1: Migração Manual
Use este guia para atualizar cada arquivo manualmente.

### Opção 2: Migração Assistida
Peça ajuda para migrar arquivos específicos:
- "Migra o sign_in.dart"
- "Migra todos os arquivos de auth"
- "Migra o dashboard.dart"

### Opção 3: Migração em Lote
Migrar grupos de arquivos relacionados de uma vez.

## ⚠️ IMPORTANTE

**O projeto NÃO VAI COMPILAR** até que todos os arquivos que usam os controllers deletados sejam atualizados para usar os providers Riverpod.

Recomendo começar pelos arquivos de autenticação para que você possa fazer login e testar o sistema.

---

**Status**: Controllers deletados, 25 arquivos precisam ser atualizados  
**Prioridade**: Começar por autenticação (sign_in, sign_up, forgot_pass)
