import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_localizations.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  final String currentLanguage;

  const LevelSelectScreen({
    Key? key,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  Map<int, int> levelScores = {};
  int unlockedLevel = 1;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockedLevel = prefs.getInt('unlockedLevel') ?? 1;
      for (int i = 1; i <= 500; i++) {
        int? score = prefs.getInt('level_${i}_score');
        if (score != null) {
          levelScores[i] = score;
        }
      }
    });
  }

  String _getDifficultyLabel(int level) {
    final local = AppLocalizations(widget.currentLanguage);
    if (level <= 125) return local.translate('easy');
    if (level <= 250) return local.translate('medium');
    if (level <= 375) return local.translate('hard');
    return local.translate('expert');
  }

  Color _getDifficultyColor(int level) {
    if (level <= 125) return Colors.green;
    if (level <= 250) return Colors.orange;
    if (level <= 375) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations(widget.currentLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.translate('selectLevel')),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.blue.shade500],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade700, Colors.blue.shade300],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: 500,
          itemBuilder: (context, index) {
            final level = index + 1;
            final difficulty = _getDifficultyLabel(level);
            final color = _getDifficultyColor(level);
            final isUnlocked = level <= unlockedLevel;
            final score = levelScores[level];
            final isCompleted = score != null;

            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (index % 20) * 30),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: isUnlocked
                    ? () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SudokuGameScreen(
                              level: level,
                              difficulty: difficulty,
                              currentLanguage: widget.currentLanguage,
                            ),
                          ),
                        );
                        if (result != null) {
                          await _loadProgress();
                        }
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isUnlocked
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color, color.withOpacity(0.7)],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey.shade400, Colors.grey.shade600],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: isUnlocked ? color.withOpacity(0.4) : Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isUnlocked)
                        Icon(
                          Icons.lock,
                          color: Colors.white.withOpacity(0.7),
                          size: 40,
                        )
                      else ...[
                        Text(
                          '$level',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            difficulty,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isCompleted)
                          Column(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$score',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}