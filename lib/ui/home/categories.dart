import 'package:app_pibb/ui/card/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/responsive.dart';
import '../../data/models/category.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/category_provider.dart';

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  // Controller
  final nameController = TextEditingController();

  //methods
  void create() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Categoria'),
        actions: [
          TextButton(
            onPressed: () {
              nameController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                final cat = Categories(name: nameController.text.trim());
                await ref
                    .read(categoryServiceProvider.notifier)
                    .addCategory(cat);
                nameController.clear();
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: '   Digite o nome da categoria...   ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        centerTitle: true,
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('Sem categorias'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Responsive(
              mobile: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    CategoryCard(cat: categories[index]),
              ),
              tablet: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    CategoryCard(cat: categories[index]),
              ),
              desktop: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    CategoryCard(cat: categories[index]),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          if (error.toString().contains('invalidjwttoken')) {
            Future.microtask(
              () => ref.read(authServiceProvider.notifier).signOut(),
            );
            return const Center(child: Text('Sessão expirada.'));
          }
          return Center(child: Text('Erro: $error'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: create,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
