import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectCtrl extends GetxController {
  final _connectivity = Connectivity();
  final isConnected = true.obs;

  @override
  void onInit() {
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      isConnected.value = result != ConnectivityResult.none;
    });
    super.onInit();
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    isConnected.value = result != ConnectivityResult.none;
  }
}
