// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../data/providers/profile_provider.dart';

class PermitGate extends ConsumerWidget {
  const PermitGate({super.key, required this.child, required this.value});
  final String value;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    // Normalização para evitar erros de maiúsculas/minúsculas vindos da DB
    final userLevel = (profile?.level ?? '').trim().toLowerCase();
    final requiredLevel = value.trim().toLowerCase();

    final isPermitted = userLevel == 'admin' || userLevel == requiredLevel;

    if (!isPermitted) return const SizedBox.shrink();
    return child;
  }
}
