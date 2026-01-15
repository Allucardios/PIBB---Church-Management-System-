// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/responsive.dart';
import '../../core/const/theme.dart';
import '../../data/providers/profile_provider.dart';
import 'profile.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(allProfilesProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      body: profilesAsync.when(
        data: (profiles) {
          final filteredProfiles = profiles
              .where((doc) => doc.email != 'silviano339@gmail.com')
              .toList();

          if (filteredProfiles.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado'));
          }

          Widget buildItem(int index) {
            final doc = filteredProfiles[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppTheme.secondary,
                    border: Border.all(color: AppTheme.primary, width: 2),
                  ),
                  child: const Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.person_2_outlined,
                      color: AppTheme.primary,
                      size: 25,
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
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Responsive(
              mobile: ListView.builder(
                itemCount: filteredProfiles.length,
                itemBuilder: (context, index) => buildItem(index),
              ),
              tablet: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredProfiles.length,
                itemBuilder: (context, index) => buildItem(index),
              ),
              desktop: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 4.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredProfiles.length,
                itemBuilder: (context, index) => buildItem(index),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
