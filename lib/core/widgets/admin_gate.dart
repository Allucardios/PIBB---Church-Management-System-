// Libraries
import 'package:flutter/material.dart';

// Local Imports
import '../../data/controllers/profile.dart';
import '../../data/models/user.dart';
import '../const/functions.dart';

class PermitGate extends StatelessWidget {
  const PermitGate({super.key, required this.child, required this.value});
  final String value;
  final Widget child;
  @override
  Widget build(BuildContext context) => StreamBuilder<List<Profile>>(
    stream: ProfileCtrl().getAllProfiles(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return SizedBox.shrink();
      final profiles = snapshot.data!;
      final current = profiles.firstWhere(
        (p) => p.id == uid,
        orElse: () => Profile(id: uid, name: "", role: "Membro", level: 'User'),
      );

      final isPermited = current.level == value;
      if (!isPermited) return SizedBox.shrink();
      return child; //
    },
  );
}
