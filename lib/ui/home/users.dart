// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/theme.dart';
import '../../data/providers/profile_provider.dart';
import 'profile.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(allProfilesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: profilesAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado'));
          }
          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final doc = profiles[index];
              // Skip the developer profile
              if (doc.email == 'silviano339@gmail.com')
                return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 2,
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppTheme.secondary,
                      border: Border.all(color: AppTheme.primary, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.person_2_outlined,
                        color: AppTheme.primary,
                        size: 30,
                      ),
                    ),
                  ),
                  title: Text(
                    doc.name ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    doc.email ?? '',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(prof: doc, isAdmin: true),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
