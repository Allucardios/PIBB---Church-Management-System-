# 🚀 Riverpod - Referência Rápida

## 📦 Providers Disponíveis

### 🔐 Autenticação
```dart
// Estado do usuário
ref.watch(authNotifierProvider)                    // User?
ref.watch(authLoadingNotifierProvider)             // bool
ref.watch(authErrorNotifierProvider)               // String

// Ações
ref.read(authServiceProvider.notifier).signIn(email, password, context)
ref.read(authServiceProvider.notifier).signUp(name, email, password)
```

### 👤 Perfil
```dart
// Estado
ref.watch(currentProfileProvider)                  // Profile?
ref.watch(allProfilesProvider)                     // AsyncValue<List<Profile>>
ref.watch(profileByIdProvider(id))                 // AsyncValue<Profile?>
ref.watch(currentUserStreamProvider)               // AsyncValue<Profile?>

// Ações
ref.read(currentProfileProvider.notifier).updateProfile(profile)
ref.read(currentProfileProvider.notifier).logout(context)
ref.read(currentProfileProvider.notifier).isAdmin()
ref.read(currentProfileProvider.notifier).canEdit()
ref.read(profileServiceProvider.notifier).updateProf(profile)
```

### 💰 Finanças
```dart
// Streams
ref.watch(incomeStreamProvider)                    // AsyncValue<List<Income>>
ref.watch(expenseStreamProvider)                   // AsyncValue<List<Expense>>

// Estado
ref.watch(selectedMonthProvider)                   // DateTime
ref.watch(selectedYearProvider)                    // int

// Mudar estado
ref.read(selectedMonthProvider.notifier).setMonth(DateTime(2024, 12))
ref.read(selectedYearProvider.notifier).setYear(2024)

// CRUD
ref.read(financeServiceProvider.notifier).addIncome(income)
ref.read(financeServiceProvider.notifier).addExpense(expense)
ref.read(financeServiceProvider.notifier).deleteIncome(id)
ref.read(financeServiceProvider.notifier).deleteExpense(id)

// Cálculos
final calc = ref.read(financeCalculationsProvider.notifier);
calc.getMonthlyIncome(incomes, month)
calc.getMonthlyExpenses(expenses, month)
calc.getMonthlyBalance(incomes, expenses, month)
calc.getYearlyIncome(incomes, year)
calc.getYearlyExpenses(expenses, year)
calc.getYearlyBalance(incomes, expenses, year)
calc.getExpensesByCategory(expenses, month)
calc.getMonthlyEvolution(incomes, expenses, year)
```

### 📁 Categorias
```dart
// Stream
ref.watch(categoriesStreamProvider)                // AsyncValue<List<Categories>>

// CRUD
ref.read(categoryServiceProvider.notifier).addCategory(category)
ref.read(categoryServiceProvider.notifier).updateCategory(category)
ref.read(categoryServiceProvider.notifier).deleteCategory(id)
```

### 🌐 Conectividade
```dart
ref.watch(connectivityStatusProvider)              // bool
```

## 🎨 Padrões de Uso

### ConsumerWidget (Recomendado)
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(provider);
    return Text('$data');
  }
}
```

### ConsumerStatefulWidget
```dart
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(provider);
    return Text('$data');
  }
}
```

### Consumer (dentro de widget)
```dart
Consumer(
  builder: (context, ref, child) {
    final data = ref.watch(provider);
    return Text('$data');
  },
)
```

## 🔄 AsyncValue (Streams)

### Método .when()
```dart
asyncValue.when(
  data: (data) => Text('Dados: $data'),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Erro: $error'),
)
```

### Método .maybeWhen()
```dart
asyncValue.maybeWhen(
  data: (data) => Text('Dados: $data'),
  orElse: () => Text('Carregando...'),
)
```

### Propriedades
```dart
asyncValue.hasValue      // bool
asyncValue.value         // T? (pode ser null)
asyncValue.hasError      // bool
asyncValue.error         // Object?
asyncValue.isLoading     // bool
```

## 🎯 ref.watch() vs ref.read()

### ref.watch()
- ✅ Observa mudanças
- ✅ Reconstrói o widget
- ✅ Use no build()
```dart
final data = ref.watch(provider);
```

### ref.read()
- ✅ Lê valor uma vez
- ❌ NÃO reconstrói
- ✅ Use em callbacks/eventos
```dart
onPressed: () {
  ref.read(provider.notifier).action();
}
```

## 🚦 Navegação

### Push
```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => NextPage()),
)
```

### Pop
```dart
Navigator.of(context).pop()
```

### Replace All
```dart
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (_) => HomePage()),
  (route) => false,
)
```

## 🔨 Comandos Build Runner

### Build
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch
```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Clean
```bash
dart run build_runner clean
```

## ⚡ Dicas Rápidas

1. **Sempre use ConsumerWidget** quando possível
2. **ref.watch()** no build, **ref.read()** em callbacks
3. **AsyncValue.when()** para streams
4. **Não esqueça** de adicionar `part 'file.g.dart'` nos providers
5. **Execute build_runner** após criar/modificar providers

## 🎓 Exemplos Completos

Ver arquivo: `lib/core/examples/riverpod_examples.dart`

---

**Documentação completa:** `MIGRATION_GUIDE.md`
**Status da migração:** `MIGRATION_STATUS.md`
