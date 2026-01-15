// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/admin_gate.dart';
import '../../core/widgets/responsive.dart';
import '../../data/providers/profile_provider.dart';
import '../home/categories.dart';
import '../home/profile.dart';
import '../home/report.dart';
import '../home/users.dart';

class MyDrawer extends ConsumerWidget {
  final Function(int)? onPageChanged;
  final int? currentPage;

  const MyDrawer({super.key, this.onPageChanged, this.currentPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktop(context);

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .15,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/icon.png',
                        height: size.height * .15,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: theme.primaryColor, thickness: 2),

              // Navigation for Desktop
              if (isDesktop && onPageChanged != null) ...[
                _listTile(
                  function: () => onPageChanged!(0),
                  title: 'Casa',
                  subtitle: 'Dashboard Principal',
                  icon: Icons.house_outlined,
                  selected: currentPage == 0,
                ),
                _listTile(
                  function: () => onPageChanged!(1),
                  title: 'Receitas',
                  subtitle: 'Gestão de Entradas',
                  icon: Icons.monetization_on_outlined,
                  selected: currentPage == 1,
                ),
                _listTile(
                  function: () => onPageChanged!(2),
                  title: 'Despesas',
                  subtitle: 'Gestão de Saídas',
                  icon: Icons.shopping_cart_outlined,
                  selected: currentPage == 2,
                ),
                const Divider(),
              ],

              _listTile(
                function: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(isAdmin: false),
                  ),
                ),
                title: 'Meu Perfil',
                subtitle: 'Dados do Membro',
                icon: Icons.person_2_outlined,
              ),
              _listTile(
                function: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ReportPage())),
                title: 'Relatórios',
                subtitle: 'Gerar Relatório',
                icon: Icons.print_outlined,
              ),
              PermitGate(
                value: 'Admin',
                child: _listTile(
                  function: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const UserPage())),
                  title: 'Usuarios',
                  subtitle: 'Gerir Usuarios',
                  icon: Icons.groups_outlined,
                ),
              ),
              PermitGate(
                value: 'Admin',
                child: _listTile(
                  function: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                  ),
                  title: 'Categoria',
                  subtitle: 'Gerir Categorias',
                  icon: Icons.category_outlined,
                ),
              ),
              _listTile(
                function: () async {
                  final response = await showYesNoDialog(
                    context: context,
                    title: 'Terminar Sessão',
                    message: 'Deseja terminar a Sessão?',
                  );
                  if (response) {
                    await ref
                        .read(currentProfileProvider.notifier)
                        .logout(context);
                  }
                },
                title: 'Sair',
                subtitle: 'Terminar Sessão',
                icon: Icons.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listTile({
    required VoidCallback function,
    required String title,
    required String subtitle,
    required IconData icon,
    bool selected = false,
  }) {
    return ListTile(
      onTap: function,
      selected: selected,
      selectedTileColor: AppTheme.secondary.withOpacity(0.1),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      leading: Icon(
        icon,
        color: selected ? AppTheme.primary : Colors.grey,
        size: 25,
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
    );
  }
}
