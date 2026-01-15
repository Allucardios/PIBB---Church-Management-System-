import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//
import 'core/const/app_config.dart';
import 'core/const/theme.dart';
import 'core/widgets/auth_gate.dart';
import 'data/service/bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_PT', null);
  await Supabase.initialize(
    url: AppConfig.url,
    anonKey: AppConfig.anonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: AuthGate(),
      initialBinding: AppBinding(),
    );
  }
}
