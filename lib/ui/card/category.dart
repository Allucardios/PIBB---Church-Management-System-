import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/const/theme.dart';
import '../../data/models/category.dart';
import '../../data/providers/category_provider.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key, required this.cat});
  final Categories cat;

  void delete(BuildContext context, WidgetRef ref, Categories cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Categoria'),
        content: Text('Deseja realmente eliminar a categoria "${cat.name}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(categoryServiceProvider.notifier)
                  .deleteCategory(cat.id!);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.category_outlined, color: AppTheme.primary),
        ),
        title: Text(cat.name),
        subtitle: const Text("Categoria"),
        trailing: IconButton(
          onPressed: () => delete(context, ref, cat),
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        ),
      ),
    );
  }
}
