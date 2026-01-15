// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/theme.dart';
import '../../data/models/user.dart';
import '../../data/providers/profile_provider.dart';
import '../form/profile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key, this.prof, required this.isAdmin});
  final bool isAdmin;
  final Profile? prof;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If prof is passed (from Admin view), use it. Otherwise watch current user's profile.
    final currentUserProfile = ref.watch(currentProfileProvider);
    final user = prof ?? currentUserProfile;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Perfil' : 'Meu Perfil'),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => ProfileForm(prof: user, isAdmin: isAdmin),
            ),
            icon: const Icon(Icons.edit_outlined, color: Colors.redAccent),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 8,
            children: [
              Container(
                height: size.height * .25,
                width: double.infinity,
                decoration: const BoxDecoration(color: AppTheme.primary),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset('assets/icon.png'),
                  ),
                ),
              ),
              _buildCard(user.name ?? '', 'Nome Completo'),
              _buildCard(user.email ?? '', 'Email'),
              _buildCard(
                (user.phone == null || user.phone == '')
                    ? 'Sem Telefone'
                    : user.phone!,
                'Telefone',
              ),
              _buildCard(user.role ?? 'Membro', 'Função'),
              _buildCard(user.level, 'Nivel de Acesso'),
              _buildCard(statusLabel(user.active ?? false), 'Status'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return ListTile(title: Text(title), subtitle: Text(value));
  }

  String statusLabel(bool isActive) {
    return isActive ? 'Ativo' : 'Inactivo';
  }
}
