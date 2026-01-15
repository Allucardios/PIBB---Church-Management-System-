// Libraries
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Local Imports
import '../../core/const/app_config.dart';
import '../../core/const/functions.dart';
import '../models/category.dart';

part 'category_provider.g.dart';

/// Categories Stream Provider
@riverpod
Stream<List<Categories>> categoriesStream(CategoriesStreamRef ref) {
  return client
      .from(AppConfig.tableCategory)
      .stream(primaryKey: ['id'])
      .order('name', ascending: true)
      .map((rows) => rows.map((e) => Categories.fromJson(e)).toList());
}

/// Category Service Provider
@riverpod
class CategoryService extends _$CategoryService {
  @override
  void build() {}

  Future<void> addCategory(Categories cat) async =>
      await client.from(AppConfig.tableCategory).insert(cat.toJson());

  Future<void> updateCategory(Categories cat) async => await client
      .from(AppConfig.tableCategory)
      .update(cat.toJson())
      .eq('id', cat.id!);

  Future<void> deleteCategory(int id) async =>
      await client.from(AppConfig.tableCategory).delete().eq('id', id);
}
