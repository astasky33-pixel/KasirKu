import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/hive_service.dart';
import 'providers/calculator_provider.dart';
import 'providers/notes_provider.dart';
import 'providers/analytics_provider.dart';
import 'views/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await HiveService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()..loadNotes()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()..loadTransactions()),
      ],
      child: const KasirKuApp(),
    ),
  );
}

class KasirKuApp extends StatelessWidget {
  const KasirKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KasirKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainScaffold(),
    );
  }
}
