import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';
import '../widgets/menu_button.dart';
import '../widgets/language_button.dart';
import 'level_select_screen.dart';
import 'progress_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChange;

  const MainMenuScreen({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations(currentLanguage);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade700,
              Colors.blue.shade500,
              Colors.pink.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Dil Seçimi Butonları
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    LanguageButton(
                      flag: '🇹🇷',
                      isSelected: currentLanguage == 'tr',
                      onTap: () => onLanguageChange('tr'),
                    ),
                    const SizedBox(width: 8),
                    LanguageButton(
                      flag: '🇬🇧',
                      isSelected: currentLanguage == 'en',
                      onTap: () => onLanguageChange('en'),
                    ),
                  ],
                ),
              ),
              // Ana İçerik
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo ve Başlık
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.grid_4x4,
                            size: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            local.translate('title'),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black45,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            local.translate('subtitle'),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    // Menü Butonları
                    MenuButton(
                      icon: Icons.play_arrow,
                      label: local.translate('play'),
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelSelectScreen(
                              currentLanguage: currentLanguage,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    MenuButton(
                      icon: Icons.leaderboard,
                      label: local.translate('progress'),
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgressScreen(
                              currentLanguage: currentLanguage,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}