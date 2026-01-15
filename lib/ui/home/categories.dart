import 'package:app_pibb/ui/card/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/controllers/category.dart';
import '../../data/models/category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // DB
  final ctrl = CategoryCtrl();
  // Controller
  final name = TextEditingController();
  //methods
  void create() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Nova Categoria'),
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
              final cat = Categories(name: name.text.trim());
              ctrl.createCat(cat);
              name.clear();
              Navigator.pop(context);
            },
            child: Text('Salvar'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
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
    return Scaffold(
      appBar: AppBar(title: Text('Categorias'), centerTitle: true),
      body: StreamBuilder(
        stream: ctrl.readCats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Sem dados'));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final map = snapshot.data!;
          return ListView.builder(
            itemCount: map.length,
            itemBuilder: (context, index) => CategoryCard(cat: map[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => create(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
