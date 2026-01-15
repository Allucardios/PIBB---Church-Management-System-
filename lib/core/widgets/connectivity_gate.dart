// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../data/providers/connectivity_provider.dart';

class ConnectivityGate extends ConsumerWidget {
  const ConnectivityGate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityStatusProvider);

    if (!isConnected) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'Sem conexão à internet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Por favor, verifique a sua ligação para continuar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return child;
  }
}
