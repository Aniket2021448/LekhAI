import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/slip.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SlipAdapter());
  await Hive.openBox<Slip>('slips');

  runApp(const LekhAIApp());
}

class LekhAIApp extends StatelessWidget {
  const LekhAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LekHAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
