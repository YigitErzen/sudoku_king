import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';

class HowToPlayScreen extends StatelessWidget {
  final String currentLanguage;

  const HowToPlayScreen({
    Key? key,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations(currentLanguage);
    final bool isTurkish = currentLanguage == 'tr';

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
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        isTurkish ? 'NASIL OYNANIR?' : 'HOW TO PLAY?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Icon(Icons.help_outline, color: Colors.white, size: 32),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Sudoku Nedir
                        _TitleCard(
                          icon: Icons.grid_4x4,
                          title: isTurkish ? 'SUDOKU NEDİR?' : 'WHAT IS SUDOKU?',
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 16),
                        _DescriptionCard(
                          description: isTurkish 
                            ? 'Sudoku, 9x9\'luk bir ızgarada oynanan sayı bulmaca oyunudur. Amaç, her satır, sütun ve 3x3\'lük küçük karelerde 1\'den 9\'a kadar tüm sayıları kullanmaktır.'
                            : 'Sudoku is a number puzzle game played on a 9x9 grid. The goal is to use all numbers from 1 to 9 in each row, column and 3x3 small square.',
                        ),

                        const SizedBox(height: 24),

                        // Temel Kurallar
                        _TitleCard(
                          icon: Icons.rule,
                          title: isTurkish ? 'TEMEL KURALLAR' : 'BASIC RULES',
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 16),

                        _RuleCard(
                          number: '1',
                          title: isTurkish ? 'Satır Kuralı' : 'Row Rule',
                          description: isTurkish
                            ? 'Her satırda 1\'den 9\'a kadar her sayı sadece bir kez bulunmalı.'
                            : 'Each row must contain numbers 1 to 9 only once.',
                          icon: Icons.linear_scale,
                          color: Colors.green,
                        ),

                        _RuleCard(
                          number: '2',
                          title: isTurkish ? 'Sütun Kuralı' : 'Column Rule',
                          description: isTurkish
                            ? 'Her sütunda 1\'den 9\'a kadar her sayı sadece bir kez bulunmalı.'
                            : 'Each column must contain numbers 1 to 9 only once.',
                          icon: Icons.view_week,
                          color: Colors.orange,
                        ),

                        _RuleCard(
                          number: '3',
                          title: isTurkish ? '3x3 Kare Kuralı' : '3x3 Square Rule',
                          description: isTurkish
                            ? 'Her 3x3\'lük küçük karede 1\'den 9\'a kadar her sayı sadece bir kez bulunmalı.'
                            : 'Each 3x3 small square must contain numbers 1 to 9 only once.',
                          icon: Icons.grid_3x3,
                          color: Colors.red,
                        ),

                        const SizedBox(height: 24),

                        // Oyun Özellikleri
                        _TitleCard(
                          icon: Icons.stars,
                          title: isTurkish ? 'OYUN ÖZELLİKLERİ' : 'GAME FEATURES',
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 16),

                        _FeatureCard(
                          icon: Icons.lightbulb_outline,
                          title: isTurkish ? 'İpucu Sistemi' : 'Hint System',
                          description: isTurkish
                            ? 'Her levelde 3 ipucu hakkınız var. Takıldığınızda kullanın!'
                            : 'You have 3 hints per level. Use them when stuck!',
                          color: Colors.amber,
                        ),

                        _FeatureCard(
                          icon: Icons.close,
                          title: isTurkish ? 'Hata Limiti' : 'Mistake Limit',
                          description: isTurkish
                            ? '3 hata yapma hakkınız var. 3. hatadan sonra oyun biter!'
                            : 'You have 3 mistakes allowed. Game ends after 3rd mistake!',
                          color: Colors.red,
                        ),

                        _FeatureCard(
                          icon: Icons.star,
                          title: isTurkish ? 'Yıldız Sistemi' : 'Star System',
                          description: isTurkish
                            ? 'Puanınıza göre 1-3 yıldız kazanın. Yüksek puan = Daha fazla yıldız!'
                            : 'Earn 1-3 stars based on your score. Higher score = More stars!',
                          color: Colors.purple,
                        ),

                        const SizedBox(height: 24),

                        // Puan Sistemi
                        _TitleCard(
                          icon: Icons.emoji_events,
                          title: isTurkish ? 'PUAN SİSTEMİ' : 'SCORING SYSTEM',
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),

                        _ScoreCard(
                          icon: Icons.speed,
                          title: isTurkish ? 'Hız Bonusu' : 'Speed Bonus',
                          description: isTurkish
                            ? 'Hızlı bitirirseniz ekstra puan!'
                            : 'Finish fast for extra points!',
                        ),

                        _ScoreCard(
                          icon: Icons.check_circle,
                          title: isTurkish ? 'Hatasız Bonus' : 'No Mistake Bonus',
                          description: isTurkish
                            ? 'Hata yapmazsanız +500 puan!'
                            : 'No mistakes = +500 points!',
                        ),

                        _ScoreCard(
                          icon: Icons.lightbulb_outline,
                          title: isTurkish ? 'İpucusuz Bonus' : 'No Hint Bonus',
                          description: isTurkish
                            ? 'İpucu kullanmazsanız +300 puan!'
                            : 'No hints used = +300 points!',
                        ),

                        const SizedBox(height: 24),

                        // Zorluk Seviyeleri
                        _TitleCard(
                          icon: Icons.trending_up,
                          title: isTurkish ? 'ZORLUK SEVİYELERİ' : 'DIFFICULTY LEVELS',
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(height: 16),

                        _DifficultyCard(
                          title: isTurkish ? 'Kolay (1-125)' : 'Easy (1-125)',
                          description: isTurkish ? 'Yeni başlayanlar için' : 'For beginners',
                          color: Colors.green,
                          emptyCount: '35',
                        ),

                        _DifficultyCard(
                          title: isTurkish ? 'Orta (126-250)' : 'Medium (126-250)',
                          description: isTurkish ? 'Biraz düşünme gerektirir' : 'Requires some thinking',
                          color: Colors.orange,
                          emptyCount: '45',
                        ),

                        _DifficultyCard(
                          title: isTurkish ? 'Zor (251-375)' : 'Hard (251-375)',
                          description: isTurkish ? 'Deneyimli oyuncular için' : 'For experienced players',
                          color: Colors.red,
                          emptyCount: '52',
                        ),

                        _DifficultyCard(
                          title: isTurkish ? 'Uzman (376-500)' : 'Expert (376-500)',
                          description: isTurkish ? 'Sadece ustalar için!' : 'Masters only!',
                          color: Colors.purple,
                          emptyCount: '58',
                        ),

                        const SizedBox(height: 32),

                        // Başla Butonu
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade600, Colors.blue.shade500],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.sports_esports, size: 48, color: Colors.white),
                              const SizedBox(height: 16),
                              Text(
                                isTurkish ? 'Artık Hazırsın!' : 'You\'re Ready!',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isTurkish 
                                  ? 'Şimdi oynamaya başla ve Sudoku ustası ol!' 
                                  : 'Start playing now and become a Sudoku master!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

// Widget sınıfları
class _TitleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _TitleCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final String description;

  const _DescriptionCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _RuleCard({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ScoreCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final String emptyCount;

  const _DifficultyCard({
    required this.title,
    required this.description,
    required this.color,
    required this.emptyCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              emptyCount,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}