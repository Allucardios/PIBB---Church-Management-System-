// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../data/providers/auth_provider.dart';
import '../../data/providers/finance_provider.dart';
import '../../data/providers/profile_provider.dart';

/// ============================================================================
/// EXEMPLO 1: ConsumerWidget - Widget Simples
/// ============================================================================
class ExemploConsumerWidget extends ConsumerWidget {
  const ExemploConsumerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar o perfil atual
    final profile = ref.watch(currentProfileProvider);

    // Observar estado de loading
    final isLoading = ref.watch(authLoadingNotifierProvider);

    if (isLoading) {
      return CircularProgressIndicator();
    }

    return Text(profile?.name ?? 'Sem nome');
  }
}

/// ============================================================================
/// EXEMPLO 2: ConsumerStatefulWidget - Widget com Estado
/// ============================================================================
class ExemploConsumerStatefulWidget extends ConsumerStatefulWidget {
  const ExemploConsumerStatefulWidget({super.key});

  @override
  ConsumerState<ExemploConsumerStatefulWidget> createState() =>
      _ExemploConsumerStatefulWidgetState();
}

class _ExemploConsumerStatefulWidgetState
    extends ConsumerState<ExemploConsumerStatefulWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Observar estado de erro
    final errorMessage = ref.watch(authErrorNotifierProvider);
    final isLoading = ref.watch(authLoadingNotifierProvider);

    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        if (errorMessage.isNotEmpty)
          Text(errorMessage, style: TextStyle(color: Colors.red)),
        ElevatedButton(
          onPressed: isLoading ? null : _handleLogin,
          child: isLoading ? CircularProgressIndicator() : Text('Entrar'),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    await ref
        .read(authServiceProvider.notifier)
        .signIn(_emailController.text, _passwordController.text, context);
  }
}

/// ============================================================================
/// EXEMPLO 3: Streams com AsyncValue
/// ============================================================================
class ExemploStreamWidget extends ConsumerWidget {
  const ExemploStreamWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar stream de receitas
    final incomesAsync = ref.watch(incomeStreamProvider);

    // Usar .when() para lidar com estados
    return incomesAsync.when(
      data: (incomes) {
        if (incomes.isEmpty) {
          return Center(child: Text('Nenhuma receita encontrada'));
        }

        return ListView.builder(
          itemCount: incomes.length,
          itemBuilder: (context, index) {
            final income = incomes[index];
            return ListTile(
              title: Text(income.obs!),
              subtitle: Text(income.date.toString()),
              trailing: Text('${income.totalIncome()} AOA'),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erro: $error')),
    );
  }
}

/// ============================================================================
/// EXEMPLO 4: Múltiplos Providers
/// ============================================================================
class ExemploMultiplosProviders extends ConsumerWidget {
  const ExemploMultiplosProviders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar múltiplos providers
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final profile = ref.watch(currentProfileProvider);

    // Verificar se ambos os streams têm dados
    if (!incomesAsync.hasValue || !expensesAsync.hasValue) {
      return CircularProgressIndicator();
    }

    final incomes = incomesAsync.value ?? [];
    final expenses = expensesAsync.value ?? [];

    // Usar o provider de cálculos
    final calculations = ref.read(financeCalculationsProvider.notifier);

    final monthlyIncome = calculations.getMonthlyIncome(incomes, selectedMonth);
    final monthlyExpenses = calculations.getMonthlyExpenses(
      expenses,
      selectedMonth,
    );
    final balance = calculations.getMonthlyBalance(
      incomes,
      expenses,
      selectedMonth,
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuário: ${profile?.name ?? "Desconhecido"}'),
            SizedBox(height: 16),
            Text('Receitas: $monthlyIncome AOA'),
            Text('Despesas: $monthlyExpenses AOA'),
            Text(
              'Saldo: $balance AOA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: balance >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// EXEMPLO 5: Executar Ações (CRUD)
/// ============================================================================
class ExemploAcoes extends ConsumerWidget {
  const ExemploAcoes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _adicionarReceita(ref),
          child: Text('Adicionar Receita'),
        ),
        ElevatedButton(
          onPressed: () => _deletarReceita(ref, 1),
          child: Text('Deletar Receita'),
        ),
        ElevatedButton(
          onPressed: () => _logout(ref, context),
          child: Text('Logout'),
        ),
      ],
    );
  }

  Future<void> _adicionarReceita(WidgetRef ref) async {
    // Criar objeto Income (exemplo)
    // final income = Income(...);

    // Adicionar usando o service provider
    // await ref.read(financeServiceProvider.notifier).addIncome(income);
  }

  Future<void> _deletarReceita(WidgetRef ref, int id) async {
    await ref.read(financeServiceProvider.notifier).deleteIncome(id);
  }

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    await ref.read(currentProfileProvider.notifier).logout(context);
  }
}

/// ============================================================================
/// EXEMPLO 6: Consumer dentro de StatelessWidget
/// ============================================================================
class ExemploConsumerDentroDeWidget extends StatelessWidget {
  const ExemploConsumerDentroDeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exemplo')),
      body: Consumer(
        builder: (context, ref, child) {
          final profile = ref.watch(currentProfileProvider);

          return Center(child: Text('Olá, ${profile?.name ?? "Visitante"}'));
        },
      ),
    );
  }
}

/// ============================================================================
/// EXEMPLO 7: Atualizar Estado
/// ============================================================================
class ExemploAtualizarEstado extends ConsumerWidget {
  const ExemploAtualizarEstado({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final selectedYear = ref.watch(selectedYearProvider);

    return Column(
      children: [
        Text('Mês: ${selectedMonth.month}/${selectedMonth.year}'),
        Text('Ano: $selectedYear'),
        ElevatedButton(
          onPressed: () {
            // Atualizar mês selecionado
            ref
                .read(selectedMonthProvider.notifier)
                .setMonth(DateTime(2024, 12));
          },
          child: Text('Selecionar Dezembro 2024'),
        ),
        ElevatedButton(
          onPressed: () {
            // Atualizar ano selecionado
            ref.read(selectedYearProvider.notifier).setYear(2024);
          },
          child: Text('Selecionar Ano 2024'),
        ),
      ],
    );
  }
}

/// ============================================================================
/// EXEMPLO 8: Provider com Parâmetro
/// ============================================================================
class ExemploProviderComParametro extends ConsumerWidget {
  final String userId;

  const ExemploProviderComParametro({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider que aceita parâmetro
    final profileAsync = ref.watch(profileByIdProvider(userId));

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return Text('Perfil não encontrado');
        }
        return Text('Nome: ${profile.name}');
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Erro: $error'),
    );
  }
}
