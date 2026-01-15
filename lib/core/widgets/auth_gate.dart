// Libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../data/controllers/auth.dart';
import '../../data/controllers/connect.dart';
import '../../ui/auth/sign_in.dart';
import '../../ui/home/home.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Controllers
  final _connect = Get.find<ConnectCtrl>();
  final _auth = Get.find<AuthCtrl>();

  @override
  Widget build(BuildContext context) => Obx(() {
    if (!_connect.isConnected.value) {
      return _noInternet();
    }

    return _auth.isAuthenticated ? HomePage() : SignIn();
  });

  Widget _noInternet() => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text('Sem conexão à internet'),
        ],
      ),
    ),
  );
}
