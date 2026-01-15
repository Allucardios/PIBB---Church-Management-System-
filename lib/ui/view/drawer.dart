// Libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/admin_gate.dart';
import '../../data/controllers/profile.dart';
import '../home/categories.dart';
import '../home/profile.dart';
import '../home/report.dart';
import '../home/users.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final _ctrl = Get.find<ProfileCtrl>();
  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * .15,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icon.png',
                      height: Get.height * .15,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Get.theme.primaryColor, thickness: 2),
            _listTile(
              function: () => Get.to(() => ProfilePage(isAdmin: false)),
              title: 'Meu Perfil',
              subtitle: 'Dados do Membro',
              icon: Icons.person_2_outlined,
            ),
            _listTile(
              function: () => Get.to(() => ReportPage()),
              title: 'Relatórios',
              subtitle: 'Gerar Relatório',
              icon: Icons.print_outlined,
            ),
            PermitGate(
              value: 'Admin',
              child: _listTile(
                function: () => Get.to(() => UserPage()),
                title: 'Usuarios',
                subtitle: 'Gerir Usuarios',
                icon: Icons.groups_outlined,
              ),
            ),
            PermitGate(
              value: 'Admin',
              child: _listTile(
                function: () => Get.to(() => CategoryPage()),
                title: 'Categoria',
                subtitle: 'Gerir Categorias',
                icon: Icons.category_outlined,
              ),
            ),
            _listTile(
              function: () async {
                final response = await showYesNoDialog(
                  title: 'Terminar Sessão',
                  message: 'Deseja terminar a Sessão?',
                );
                if (response) _ctrl.logout();
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

  Widget _listTile({
    required VoidCallback function,
    required String title,
    required String subtitle,
    required IconData icon,
  }) => ListTile(
    onTap: function,
    title: Text(title, style: TextStyle(fontSize: 14)),
    subtitle: Text(subtitle, style: TextStyle(fontSize: 12)),
    leading: Icon(icon, color: AppTheme.primary, size: 25),
    trailing: Icon(Icons.chevron_right, color: AppTheme.primary),
  );
}
