// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/admin_gate.dart';
import '../../core/widgets/responsive.dart';
import '../../data/providers/profile_provider.dart';
import '../home/accounts.dart';
import '../home/categories.dart';
import '../home/profile.dart';
import '../home/report.dart';
import '../home/users.dart';
import 'about.dart';

class MyDrawer extends ConsumerWidget {
  final Function(int)? onPageChanged;
  final int? currentPage;

  const MyDrawer({super.key, this.onPageChanged, this.currentPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktop(context);

    // Use a unique key to prevent state issues when moving in the tree
    final widgetKey = ValueKey('mydrawer_${isDesktop ? "desktop" : "mobile"}');

    return Container(
      key: widgetKey,
      width: isDesktop ? 300 : size.width * 0.75,
      decoration: BoxDecoration(
        color: theme.canvasColor,
        border: isDesktop
            ? Border(right: BorderSide(color: theme.dividerColor, width: 0.5))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .15,
                child: Center(
                  child: Image.asset(
                    'assets/icon.png',
                    height: size.height * .12,
                  ),
                ),
              ),
              Divider(color: theme.primaryColor.withOpacity(0.5), thickness: 1),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                        function: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReportPage()),
                        ),
                        title: 'Relatórios',
                        subtitle: 'Gerar Relatório',
                        icon: Icons.print_outlined,
                      ),
                      PermitGate(
                        value: 'Admin',
                        child: _listTile(
                          function: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const UserPage()),
                          ),
                          title: 'Utilizadores',
                          subtitle: 'Gerir Utilizadores',
                          icon: Icons.groups_outlined,
                        ),
                      ),
                      PermitGate(
                        value: 'Admin',
                        child: _listTile(
                          function: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CategoryPage(),
                            ),
                          ),
                          title: 'Categorias',
                          subtitle: 'Gerir Categorias',
                          icon: Icons.category_outlined,
                        ),
                      ),
                      PermitGate(
                        value: 'Manager',
                        child: _listTile(
                          function: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AccountPage(),
                            ),
                          ),
                          title: 'Contas',
                          subtitle: 'Gestão de Contas',
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ),
                      _listTile(
                        function: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AboutPage()),
                        ),
                        title: 'Sobre',
                        subtitle: 'Manual e Info',
                        icon: Icons.info_outline,
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
      selectedTileColor: AppTheme.primary.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          color: selected ? AppTheme.primary : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      leading: Icon(
        icon,
        color: selected ? AppTheme.primary : Colors.grey.shade600,
        size: 24,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: selected ? AppTheme.primary : Colors.grey.shade400,
        size: 20,
      ),
    );
  }
}
