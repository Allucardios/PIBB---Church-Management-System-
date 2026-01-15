# 🏗️ Arquitetura do Projeto - Riverpod

## 📊 Estrutura de Diretórios

```
app_pibb/
├── lib/
│   ├── main.dart                          # ProviderScope + MaterialApp
│   │
│   ├── core/                              # Núcleo da aplicação
│   │   ├── const/
│   │   │   ├── app_config.dart           # Configurações
│   │   │   ├── functions.dart            # Funções utilitárias
│   │   │   ├── theme.dart                # Tema
│   │   │   └── ...
│   │   ├── widgets/
│   │   │   ├── auth_gate.dart            # ✅ Migrado para Riverpod
│   │   │   └── ...
│   │   └── examples/
│   │       └── riverpod_examples.dart    # 8 exemplos práticos
│   │
│   ├── data/                              # Camada de dados
│   │   ├── models/                        # Modelos de dados
│   │   │   ├── user.dart
│   │   │   ├── income.dart
│   │   │   ├── expense.dart
│   │   │   └── category.dart
│   │   │
│   │   ├── providers/                     # ✅ NOVO - Riverpod Providers
│   │   │   ├── auth_provider.dart        # Autenticação
│   │   │   ├── profile_provider.dart     # Perfis
│   │   │   ├── finance_provider.dart     # Finanças
│   │   │   ├── category_provider.dart    # Categorias
│   │   │   └── connectivity_provider.dart # Conectividade
│   │   │
│   │   ├── controllers/                   # ❌ DEPRECATED - Não usar
│   │   │   └── ...                        # (Será removido após migração)
│   │   │
│   │   └── service/
│   │       └── report.dart                # Serviços de relatório
│   │
│   └── ui/                                # Interface do usuário
│       ├── auth/                          # ⏳ Precisa migrar
│       │   ├── sign_in.dart
│       │   ├── sign_up.dart
│       │   └── forgot_pass.dart
│       │
│       ├── home/                          # ⏳ Precisa migrar
│       │   ├── home.dart
│       │   ├── dashboard.dart
│       │   ├── income.dart
│       │   ├── expenses.dart
│       │   └── ...
│       │
│       ├── form/                          # ⏳ Precisa migrar
│       │   ├── income.dart
│       │   ├── expense.dart
│       │   └── profile.dart
│       │
│       ├── card/                          # ⏳ Precisa migrar
│       │   ├── income.dart
│       │   ├── expense.dart
│       │   └── category.dart
│       │
│       ├── view/                          # ⏳ Precisa migrar
│       │   ├── drawer.dart
│       │   └── ...
│       │
│       └── report/                        # ⏳ Precisa migrar
│           ├── month.dart
│           ├── anual.dart
│           └── quaterly.dart
│
├── MIGRATION_GUIDE.md                     # Guia completo de migração
├── MIGRATION_STATUS.md                    # Status e próximos passos
├── RIVERPOD_QUICK_REFERENCE.md           # Referência rápida
└── ARCHITECTURE.md                        # Este arquivo
```

## 🔄 Fluxo de Dados

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                             │
│  (ConsumerWidget / ConsumerStatefulWidget / Consumer)       │
│                                                              │
│  • Observa providers com ref.watch()                        │
│  • Executa ações com ref.read()                             │
│  • Reage a mudanças automaticamente                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ ref.watch() / ref.read()
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    Provider Layer                            │
│              (lib/data/providers/)                           │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ State Notifiers                                       │  │
│  │ • authNotifierProvider                                │  │
│  │ • currentProfileProvider                              │  │
│  │ • selectedMonthProvider                               │  │
│  │ • connectivityStatusProvider                          │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Stream Providers                                      │  │
│  │ • incomeStreamProvider                                │  │
│  │ • expenseStreamProvider                               │  │
│  │ • categoriesStreamProvider                            │  │
│  │ • allProfilesProvider                                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Service Providers                                     │  │
│  │ • authServiceProvider                                 │  │
│  │ • financeServiceProvider                              │  │
│  │ • categoryServiceProvider                             │  │
│  │ • profileServiceProvider                              │  │
│  └──────────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Supabase Client
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    Data Source                               │
│                  (Supabase Backend)                          │
│                                                              │
│  • Authentication                                            │
│  • Realtime Database                                         │
│  • Storage                                                   │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Tipos de Providers

### 1. **State Notifiers** (Estado Mutável)
Gerenciam estado que pode mudar ao longo do tempo.

```dart
@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() => DateTime.now();
  
  void setMonth(DateTime month) => state = month;
}
```

**Uso:**
```dart
final month = ref.watch(selectedMonthProvider);
ref.read(selectedMonthProvider.notifier).setMonth(newMonth);
```

### 2. **Stream Providers** (Dados em Tempo Real)
Observam streams do Supabase para atualizações em tempo real.

```dart
@riverpod
Stream<List<Income>> incomeStream(IncomeStreamRef ref) {
  return client
      .from('incomes')
      .stream(primaryKey: ['id'])
      .map((rows) => rows.map((e) => Income.fromJson(e)).toList());
}
```

**Uso:**
```dart
final incomesAsync = ref.watch(incomeStreamProvider);
incomesAsync.when(
  data: (incomes) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (error, _) => Text('Erro: $error'),
);
```

### 3. **Service Providers** (Ações/CRUD)
Executam operações no banco de dados.

```dart
@riverpod
class FinanceService extends _$FinanceService {
  @override
  void build() {}
  
  Future<void> addIncome(Income inc) async =>
      await client.from('incomes').insert(inc.toJson());
}
```

**Uso:**
```dart
await ref.read(financeServiceProvider.notifier).addIncome(income);
```

### 4. **Computed Providers** (Cálculos)
Realizam cálculos baseados em dados.

```dart
@riverpod
class FinanceCalculations extends _$FinanceCalculations {
  @override
  void build() {}
  
  double getMonthlyIncome(List<Income> incomes, DateTime month) {
    // cálculo...
  }
}
```

**Uso:**
```dart
final calc = ref.read(financeCalculationsProvider.notifier);
final total = calc.getMonthlyIncome(incomes, month);
```

## 🔐 Fluxo de Autenticação

```
┌─────────────┐
│  SignIn UI  │
└──────┬──────┘
       │
       │ ref.read(authServiceProvider.notifier).signIn()
       │
       ▼
┌─────────────────────┐
│  authServiceProvider │
└──────┬──────────────┘
       │
       │ client.auth.signInWithPassword()
       │
       ▼
┌─────────────────────┐
│  Supabase Auth      │
└──────┬──────────────┘
       │
       │ onAuthStateChange
       │
       ▼
┌─────────────────────┐
│ authNotifierProvider │ ← UI observa com ref.watch()
└──────┬──────────────┘
       │
       │ state = user
       │
       ▼
┌─────────────────────┐
│  UI atualiza        │
│  (HomePage)         │
└─────────────────────┘
```

## 💰 Fluxo de Finanças

```
┌──────────────────┐
│  Income List UI  │
└────────┬─────────┘
         │
         │ ref.watch(incomeStreamProvider)
         │
         ▼
┌──────────────────────┐
│ incomeStreamProvider  │
└────────┬─────────────┘
         │
         │ client.from('incomes').stream()
         │
         ▼
┌──────────────────────┐
│  Supabase Realtime   │
└────────┬─────────────┘
         │
         │ Stream<List<Income>>
         │
         ▼
┌──────────────────────┐
│  AsyncValue<List>    │ ← UI usa .when()
└──────────────────────┘
```

## 📱 Exemplo de Widget Completo

```dart
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observar múltiplos providers
    final profile = ref.watch(currentProfileProvider);
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    
    // 2. Verificar loading
    if (!incomesAsync.hasValue || !expensesAsync.hasValue) {
      return CircularProgressIndicator();
    }
    
    // 3. Extrair dados
    final incomes = incomesAsync.value ?? [];
    final expenses = expensesAsync.value ?? [];
    
    // 4. Calcular
    final calc = ref.read(financeCalculationsProvider.notifier);
    final balance = calc.getMonthlyBalance(incomes, expenses, selectedMonth);
    
    // 5. Renderizar UI
    return Scaffold(
      appBar: AppBar(title: Text('Olá, ${profile?.name}')),
      body: Column(
        children: [
          Text('Saldo: $balance AOA'),
          ElevatedButton(
            onPressed: () {
              // 6. Executar ação
              ref.read(selectedMonthProvider.notifier).setMonth(
                DateTime(2024, 12),
              );
            },
            child: Text('Mudar Mês'),
          ),
        ],
      ),
    );
  }
}
```

## 🎨 Convenções de Nomenclatura

### Providers
- **State Notifiers:** `selectedMonthProvider`, `authNotifierProvider`
- **Streams:** `incomeStreamProvider`, `categoriesStreamProvider`
- **Services:** `authServiceProvider`, `financeServiceProvider`
- **Computed:** `financeCalculationsProvider`

### Arquivos
- **Providers:** `*_provider.dart` (ex: `auth_provider.dart`)
- **Models:** `*.dart` (ex: `user.dart`, `income.dart`)
- **UI:** `*.dart` (ex: `sign_in.dart`, `dashboard.dart`)

## 🚀 Benefícios da Nova Arquitetura

1. **Separação Clara de Responsabilidades**
   - UI só renderiza
   - Providers gerenciam estado
   - Services executam ações

2. **Type-Safe**
   - Erros em tempo de compilação
   - Autocompletar melhorado

3. **Testável**
   - Providers podem ser facilmente mockados
   - Testes unitários mais simples

4. **Performance**
   - Rebuilds otimizados
   - Apenas widgets necessários são reconstruídos

5. **Realtime**
   - Streams do Supabase integrados
   - Atualizações automáticas

6. **Manutenível**
   - Código mais limpo
   - Menos boilerplate
   - Mais fácil de entender

---

**Documentação relacionada:**
- `MIGRATION_GUIDE.md` - Guia de migração
- `MIGRATION_STATUS.md` - Status atual
- `RIVERPOD_QUICK_REFERENCE.md` - Referência rápida
