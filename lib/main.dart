import 'package:flutter/material.dart';
import 'app/app_shell.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BuscaDogApp());
}

class BuscaDogApp extends StatelessWidget {
  const BuscaDogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuscaDog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AppShell(),
    );
  }
}
