import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/const/theme.dart';
import '../../data/controllers/category.dart';
import '../../data/models/category.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key, required this.cat});
  final Categories cat;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final ctrl = Get.find<CategoryCtrl>();
  final name = TextEditingController();
  final key = GlobalKey<FormState>();

  void delete(Categories cat) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Categoria'),
        actions: [
          TextButton(
            onPressed: () {
              name.clear();
              Get.back();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ctrl.deleteCat(cat);
              Get.back();
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.category_outlined, color: AppTheme.primary)),
        title: Text(widget.cat.name),
        subtitle: Text("Categoria"),
        trailing: IconButton(
          onPressed: () => delete(widget.cat),
          icon: Icon(Icons.delete_outline, color: Colors.redAccent),
        ),
      ),
    );
  }
}
