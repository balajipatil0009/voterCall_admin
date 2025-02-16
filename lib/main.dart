import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yfmnauejmuepdsnffqfo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlmbW5hdWVqbXVlcGRzbmZmcWZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzODEwNDEsImV4cCI6MjA1NDk1NzA0MX0.hpc57fsqss23eO5c-ZELFz13NpvAJjEi1NAWpAZTpPI',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voter Issues App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Assuming dark theme based on image
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey[850]),
        cardColor: Colors.grey[800],
        listTileTheme: ListTileThemeData(tileColor: Colors.grey[800]),
      ),
      home: const HomeScreen(),
    );
  }
}

final supabase =
    Supabase.instance.client; // Make supabase client globally accessible
