// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../data/providers/auth_provider.dart';
import '../../data/providers/profile_provider.dart';
import '../../ui/auth/sign_in.dart';
import '../../ui/home/home.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final profile = ref.watch(currentProfileProvider);

    if (user == null) return const SignIn();

    // If profile is loaded and user is inactive, they must stay at SignIn
    if (profile != null && profile.active == false) {
      return const SignIn();
    }

    return const HomePage();
  }
}
