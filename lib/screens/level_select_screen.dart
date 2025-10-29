import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_localizations.dart';
import '../services/storage_service.dart';
import '../widgets/stars_display.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  final String currentLanguage;

  const LevelSelectScreen({
    super.key,
    required this.currentLanguage,
  });

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  Map<int, int> levelScores = {};
  Map<int, int> levelStars = {};
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
        int? stars = prefs.getInt('level_${i}_stars');
        if (stars != null) {
          levelStars[i] = stars;
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade800,
              Colors.purple.shade600,
              Colors.blue.shade500,
              Colors.pink.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst Bar - Şık Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Geri Butonu
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Başlık
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            local.translate('selectLevel'),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '${unlockedLevel - 1}/500 ${local.translate('completed')}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // İlerleme Göstergesi
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${levelScores.values.fold(0, (sum, score) => sum + score)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Level Grid
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: 500,
                      itemBuilder: (context, index) {
                        final level = index + 1;
                        final color = _getDifficultyColor(level);
                        final isUnlocked = level <= unlockedLevel;
                        final score = levelScores[level];
                        final stars = levelStars[level] ?? 0;
                        final isCompleted = score != null; // Tamamlanmış mı?

                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 200 + (index % 25) * 20),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
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
                                          difficulty: _getDifficultyLabel(level),
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
                                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                                      ),
                                borderRadius: BorderRadius.circular(16),
                                // 🏆 ALTIN KENARLIK - TÜM tamamlanan leveller için!
                                border: isCompleted
                                    ? Border.all(
                                        color: Colors.amber,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: isCompleted 
                                        ? Colors.amber.withOpacity(0.5) 
                                        : isUnlocked 
                                            ? color.withOpacity(0.3) 
                                            : Colors.grey.withOpacity(0.2),
                                    blurRadius: isCompleted ? 12 : 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Arka Plan Deseni
                                  if (isUnlocked)
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CustomPaint(
                                          painter: _GridPatternPainter(color: Colors.white.withOpacity(0.1)),
                                        ),
                                      ),
                                    ),
                                  
                                  // İçerik
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (!isUnlocked)
                                          Icon(
                                            Icons.lock,
                                            color: Colors.white.withOpacity(0.6),
                                            size: 32,
                                          )
                                        else ...[
                                          Text(
                                            '$level',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          if (isCompleted) ...[
                                            StarsDisplay(
                                              stars: stars,
                                              size: 14,
                                              showCircle: false,
                                            ),
                                          ] else ...[
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                widget.currentLanguage == 'tr' ? 'YENİ' : 'NEW',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ],
                                    ),
                                  ),
                                  
                                  // Tamamlanma işareti - TÜM tamamlanan leveller için
                                  if (isCompleted)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.amber.withOpacity(0.6),
                                              blurRadius: 10,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(        
                                         Icons.check,        
                                          color: Colors.white,
                                          size: 8,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Arka plan için grid deseni
class _GridPatternPainter extends CustomPainter {
  final Color color;
  
  _GridPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    
    // Yatay çizgiler
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(0, size.height / 3 * i),
        Offset(size.width, size.height / 3 * i),
        paint,
      );
    }
    
    // Dikey çizgiler
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(size.width / 3 * i, 0),
        Offset(size.width / 3 * i, size.height),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}