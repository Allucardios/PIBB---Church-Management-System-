// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../data/providers/auth_provider.dart';
import '../../ui/auth/sign_in.dart';
import '../../ui/home/home.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);

    return user != null ? HomePage() : SignIn();
  }
}
