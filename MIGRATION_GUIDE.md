# Migração GetX → Riverpod - Guia Completo

## 📋 Resumo das Mudanças

Este projeto foi migrado de **GetX** para **Riverpod** para melhor gerenciamento de estado e arquitetura mais limpa.

## 🔄 Principais Alterações

### 1. Dependências (pubspec.yaml)
**Removido:**
- `get`
- `get_storage`

**Adicionado:**
- `flutter_riverpod: ^2.6.1`
- `riverpod_annotation: ^2.6.1`
- `build_runner: ^2.4.13` (dev)
- `riverpod_generator: ^2.6.1` (dev)

### 2. Estrutura de Diretórios
```
lib/
├── data/
│   ├── controllers/  ❌ (DEPRECATED - não usar mais)
│   ├── providers/    ✅ (NOVO - usar daqui em diante)
│   │   ├── auth_provider.dart
│   │   ├── profile_provider.dart
│   │   ├── finance_provider.dart
│   │   ├── category_provider.dart
│   │   └── connectivity_provider.dart
│   ├── models/
│   └── service/
```

### 3. Providers Criados

#### **AuthProvider** (`auth_provider.dart`)
Gerencia autenticação do usuário.

**Providers disponíveis:**
- `authNotifierProvider` - Estado do usuário atual
- `authLoadingNotifierProvider` - Estado de loading
- `authErrorNotifierProvider` - Mensagens de erro
- `authServiceProvider` - Serviços de autenticação (signIn, signUp)

#### **ProfileProvider** (`profile_provider.dart`)
Gerencia perfis de usuários.

**Providers disponíveis:**
- `currentProfileProvider` - Perfil do usuário atual
- `allProfilesProvider` - Stream de todos os perfis
- `profileByIdProvider(id)` - Stream de perfil por ID
- `currentUserStreamProvider` - Stream do usuário atual
- `profileServiceProvider` - Serviços de perfil (update, etc)

#### **FinanceProvider** (`finance_provider.dart`)
Gerencia receitas e despesas.

**Providers disponíveis:**
- `incomeStreamProvider` - Stream de receitas
- `expenseStreamProvider` - Stream de despesas
- `selectedMonthProvider` - Mês selecionado
- `selectedYearProvider` - Ano selecionado
- `financeServiceProvider` - Serviços CRUD
- `financeCalculationsProvider` - Cálculos financeiros

#### **CategoryProvider** (`category_provider.dart`)
Gerencia categorias.

**Providers disponíveis:**
- `categoriesStreamProvider` - Stream de categorias
- `categoryServiceProvider` - Serviços CRUD

#### **ConnectivityProvider** (`connectivity_provider.dart`)
Monitora status de conectividade.

**Providers disponíveis:**
- `connectivityStatusProvider` - Status de conexão

## 🔨 Como Usar Riverpod

### 1. Configuração Inicial (main.dart)
```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

### 2. Consumir Providers em Widgets

#### **ConsumerWidget** (Recomendado para novos widgets)
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ler um provider
    final user = ref.watch(authNotifierProvider);
    
    // Executar uma ação
    ref.read(authServiceProvider.notifier).signIn(email, password, context);
    
    return Text(user?.email ?? 'Não autenticado');
  }
}
```

#### **Consumer** (Para widgets existentes)
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(authNotifierProvider);
        return Text(user?.email ?? 'Não autenticado');
      },
    );
  }
}
```

#### **ConsumerStatefulWidget** (Para StatefulWidgets)
```dart
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider);
    return Text(user?.email ?? 'Não autenticado');
  }
}
```

### 3. Streams com Riverpod
```dart
class IncomeListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomesAsync = ref.watch(incomeStreamProvider);
    
    return incomesAsync.when(
      data: (incomes) => ListView.builder(
        itemCount: incomes.length,
        itemBuilder: (context, index) => IncomeCard(incomes[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Erro: $error'),
    );
  }
}
```

### 4. Executar Ações
```dart
// Adicionar receita
await ref.read(financeServiceProvider.notifier).addIncome(income);

// Atualizar perfil
await ref.read(currentProfileProvider.notifier).updateProfile(profile);

// Fazer logout
await ref.read(currentProfileProvider.notifier).logout(context);
```

### 5. Cálculos Financeiros
```dart
final calculations = ref.read(financeCalculationsProvider.notifier);
final incomes = ref.watch(incomeStreamProvider).value ?? [];
final expenses = ref.watch(expenseStreamProvider).value ?? [];
final selectedMonth = ref.watch(selectedMonthProvider);

final monthlyIncome = calculations.getMonthlyIncome(incomes, selectedMonth);
final monthlyExpenses = calculations.getMonthlyExpenses(expenses, selectedMonth);
final balance = calculations.getMonthlyBalance(incomes, expenses, selectedMonth);
```

## 🔄 Migração de GetX para Riverpod

### Antes (GetX):
```dart
class MyWidget extends StatelessWidget {
  final controller = Get.find<ProfileCtrl>();
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.profile.value?.name ?? ''));
  }
}
```

### Depois (Riverpod):
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    return Text(profile?.name ?? '');
  }
}
```

## 📝 Padrões de Navegação

### Antes (GetX):
```dart
Get.to(() => HomePage());
Get.back();
Get.offAll(() => SignIn());
```

### Depois (Flutter padrão):
```dart
Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));
Navigator.of(context).pop();
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (_) => SignIn()),
  (route) => false,
);
```

## 🚀 Comandos Úteis

### Gerar código dos providers:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch mode (regenera automaticamente):
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## ⚠️ Notas Importantes

1. **Não use mais os controllers antigos** em `lib/data/controllers/`
2. **Sempre use `ref.watch()`** para observar mudanças
3. **Use `ref.read()`** para executar ações (não reconstrui o widget)
4. **ConsumerWidget** é preferível a Consumer quando possível
5. **Streams** são automaticamente gerenciados pelo Riverpod

## 📚 Recursos Adicionais

- [Documentação Riverpod](https://riverpod.dev)
- [Migração GetX → Riverpod](https://riverpod.dev/docs/from_provider/motivation)
- [Riverpod Generator](https://riverpod.dev/docs/concepts/about_code_generation)

## 🎯 Próximos Passos

1. ✅ Providers criados
2. ✅ Build runner executado
3. ⏳ Atualizar widgets da UI para usar Riverpod
4. ⏳ Remover dependências GetX antigas
5. ⏳ Testar toda a aplicação

---

**Data da Migração:** 2026-01-15
**Versão Riverpod:** 2.6.1
