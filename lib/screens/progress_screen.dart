import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_localizations.dart';

class ProgressScreen extends StatefulWidget {
  final String currentLanguage;

  const ProgressScreen({
    Key? key,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<int, Map<String, dynamic>> levelProgress = {};
  int totalScore = 0;
  int completedLevels = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    int score = 0;
    int completed = 0;
    
    for (int i = 1; i <= 500; i++) {
      int? levelScore = prefs.getInt('level_${i}_score');
      int? levelTime = prefs.getInt('level_${i}_time');
      
      if (levelScore != null) {
        levelProgress[i] = {
          'score': levelScore,
          'time': levelTime ?? 0,
        };
        score += levelScore;
        completed++;
      }
    }
    
    setState(() {
      totalScore = score;
      completedLevels = completed;
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

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations(widget.currentLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.translate('yourProgress')),
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
        child: Column(
          children: [
            // İstatistikler
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ProgressStatBox(
                    icon: Icons.emoji_events,
                    label: local.translate('totalScore'),
                    value: '$totalScore',
                    color: Colors.amber,
                  ),
                  _ProgressStatBox(
                    icon: Icons.check_circle,
                    label: local.translate('completed'),
                    value: '$completedLevels/500',
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            // Tamamlanan Leveller Listesi
            Expanded(
              child: levelProgress.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sports_esports, size: 80, color: Colors.white.withOpacity(0.5)),
                          const SizedBox(height: 20),
                          Text(
                            local.translate('noLevelsCompleted'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: levelProgress.length,
                      itemBuilder: (context, index) {
                        int level = levelProgress.keys.toList()[index];
                        var data = levelProgress[level]!;
                        String difficulty = _getDifficultyLabel(level);
                        Color color = _getDifficultyColor(level);
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [color, color.withOpacity(0.7)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '$level',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  '${local.translate('level')} $level',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    difficulty,
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text('${data['score']} ${local.translate('points').toLowerCase()}'),
                                  const SizedBox(width: 16),
                                  Icon(Icons.timer, size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(_formatTime(data['time'])),
                                ],
                              ),
                            ),
                            trailing: Icon(Icons.check_circle, color: color, size: 28),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressStatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ProgressStatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}