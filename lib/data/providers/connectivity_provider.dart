// Libraries
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Connectivity Status Provider
@riverpod
class ConnectivityStatus extends _$ConnectivityStatus {
  @override
  bool build() {
    _checkConnectivity();
    _listenToConnectivity();
    return false;
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    state = result.first != ConnectivityResult.none;
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      state = result.first != ConnectivityResult.none;
    });
  }
}
