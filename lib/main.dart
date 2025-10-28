import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_menu_screen.dart';

void main() {
  runApp(const SudokuQuestApp());
}

class SudokuQuestApp extends StatefulWidget {
  const SudokuQuestApp({super.key});

  @override
  State<SudokuQuestApp> createState() => _SudokuQuestAppState();
}

class _SudokuQuestAppState extends State<SudokuQuestApp> {
  String currentLanguage = 'tr';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLanguage = prefs.getString('language') ?? 'tr';
    });
  }

  Future<void> _setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    setState(() {
      currentLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Quest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
      ),
      home: MainMenuScreen(
        currentLanguage: currentLanguage,
        onLanguageChange: _setLanguage,
      ),
    );
  }
}