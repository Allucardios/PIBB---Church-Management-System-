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

    // Se for Admin, tem sempre permissão. Caso contrário, verifica se o nível coincide.
    final isPermitted = profile?.level == 'Admin' || profile?.level == value;

    if (!isPermitted) return const SizedBox.shrink();
    return child;
  }
}
