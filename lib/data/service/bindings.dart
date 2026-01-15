// Libraries
import 'package:get/get.dart';

// Local Imports
import '../controllers/auth.dart';
import '../controllers/category.dart';
import '../controllers/connect.dart';
import '../controllers/finance.dart';
import '../controllers/profile.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {

    /// Controllers (STATE layer)
    Get.put(ConnectCtrl(), permanent: true);
    Get.put(AuthCtrl(), permanent: true);
    Get.put(CategoryCtrl(), permanent: true);
    Get.put(ProfileCtrl(), permanent: true);
    Get.put(FinanceCtrl(), permanent: true);
  }
}
