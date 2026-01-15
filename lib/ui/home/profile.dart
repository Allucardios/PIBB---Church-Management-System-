// Libraries
import 'package:app_pibb/core/const/functions.dart';
import 'package:app_pibb/data/controllers/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/const/theme.dart';
import '../../data/models/user.dart';
import '../form/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.prof, required this.isAdmin});
  final bool isAdmin;
  final Profile? prof;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ProfileCtrl().getAllProfiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Scaffold(
            appBar: AppBar(title: Text('Perfil')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text('Perfil')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profiles = snapshot.data!;
        final user = profiles.firstWhere(
          (p) => p.id == uid,
          orElse: () =>
              Profile(id: uid, name: "", role: "Membro", level: 'user'),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(isAdmin? 'Perfil' : 'Meu Perfil'),
            actions: [
              isAdmin
                  ? IconButton(
                      onPressed: () => Get.bottomSheet(
                        ProfileForm(prof: user, isAdmin: true),
                        isScrollControlled: true,
                      ),
                      icon: Icon(Icons.edit_outlined, color: Colors.redAccent),
                    )
                  : IconButton(
                      onPressed: () => Get.bottomSheet(
                        ProfileForm(prof: user, isAdmin: false),
                        isScrollControlled: true,
                      ),
                      icon: Icon(Icons.edit_outlined, color: Colors.redAccent),
                    ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                spacing: 8,
                children: [
                  Container(
                    height: Get.height * .25,
                    width: double.infinity,
                    decoration: BoxDecoration(color: AppTheme.primary),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset('assets/icon.png'),
                      ),
                    ),
                  ),
                  _buildCard(user.name!, 'Nome Completo'),
                  _buildCard(user.email!, 'Email'),
                  _buildCard(
                    user.phone! == '' ? 'Sem Telefone' : user.phone!,
                    'Telefone',
                  ),
                  _buildCard(user.role!, 'Função'),
                  _buildCard(user.level, 'Nivel de Acesso'),
                  _buildCard(statusLabel(user.active!), 'Status'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(String title, String value) {
    return ListTile(title: Text(title), subtitle: Text(value));
  }

  String statusLabel(bool isActive) {
    return isActive ? 'Ativo' : 'Inactivo';
  }
}
