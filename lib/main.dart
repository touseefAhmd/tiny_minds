import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await StorageService.initialize();

  runApp(const TinyMindsApp());
}

class TinyMindsApp extends StatelessWidget {
  const TinyMindsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TinyMinds',
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}