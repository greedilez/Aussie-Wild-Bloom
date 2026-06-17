import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_state.dart';
import 'screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(WildBloomApp(state: await GameState.load()));
}

class WildBloomApp extends StatelessWidget {
  const WildBloomApp({super.key, required this.state});
  final GameState state;

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFC857),
      brightness: Brightness.dark,
      surface: const Color(0xFF123F43),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aussie Wild Bloom',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFF082F34),
        cardTheme: const CardThemeData(
          color: Color(0xFF12454A),
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF174F53),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: AnimatedBuilder(
        animation: state,
        builder: (_, _) => state.onboardingComplete
            ? GameShell(state: state)
            : Onboarding(state: state),
      ),
    );
  }
}
