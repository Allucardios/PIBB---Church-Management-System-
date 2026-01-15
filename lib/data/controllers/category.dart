// Libraries
import 'package:get/get.dart';

// Local Imports
import '../../core/const/app_config.dart';
import '../../core/const/functions.dart';
import '../models/category.dart';

class CategoryCtrl extends GetxController {
  final _db = client.from(AppConfig.tableCategory);
  final RxList<Categories> categories = <Categories>[].obs;

  @override
  void onInit() {
    super.onInit();
    _populateList();
  }

  ///CRUD
  ///Create
  Future createCat(Categories cat) async => await _db.insert(cat.toJson());

  ///Read
  Stream<List<Categories>> get readCats {
    return _db
        .stream(primaryKey: ['id'])
        .order('name', ascending: false)
        .map((rows) => rows.map((e) => Categories.fromJson(e)).toList())
        .asBroadcastStream();
  }

  Future<void> _populateList() async =>
      readCats.listen((list) => categories.value = list);

  ///Update
  Future updateCat(Categories cat) async =>
      await _db.update(cat.toJson()).eq('id', cat.id!);

  ///Delete
  Future deleteCat(Categories cat) async =>
      await _db.delete().eq('id', cat.id!);
}
