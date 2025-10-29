import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_localizations.dart';
import '../widgets/menu_button.dart';
import '../widgets/language_button.dart';
import 'level_select_screen.dart';
import 'progress_screen.dart';
import 'how_to_play_screen.dart';

class MainMenuScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChange;

  const MainMenuScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChange,
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final local = AppLocalizations(widget.currentLanguage);

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
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    LanguageButton(
                      flag: '🇹🇷',
                      isSelected: widget.currentLanguage == 'tr',
                      onTap: () => widget.onLanguageChange('tr'),
                    ),
                    const SizedBox(width: 8),
                    LanguageButton(
                      flag: '🇬🇧',
                      isSelected: widget.currentLanguage == 'en',
                      onTap: () => widget.onLanguageChange('en'),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/app_icon2.png',
                                width: 180,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    MenuButton(
                      icon: Icons.play_arrow,
                      label: local.translate('play'),
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelSelectScreen(
                              currentLanguage: widget.currentLanguage,
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
                              currentLanguage: widget.currentLanguage,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    MenuButton(
                      icon: Icons.help_outline,
                      label: widget.currentLanguage == 'tr' ? 'NASIL OYNANIR' : 'HOW TO PLAY',
                      color: Colors.blue,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HowToPlayScreen(
                              currentLanguage: widget.currentLanguage,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'v1.0.0 - Powered by ErzenApps',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 1,
                      ),
                    )
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