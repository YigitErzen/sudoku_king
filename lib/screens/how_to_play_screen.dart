import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';

class HowToPlayScreen extends StatelessWidget {
  final String currentLanguage;

  const HowToPlayScreen({
    super.key,
    required this.currentLanguage,
  });

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
                        isTurkish ? 'NASIL OYNANIR' : 'HOW TO PLAY',
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

                        _SimpleRuleCard(
                          title: isTurkish ? 'Satır Kuralı' : 'Row Rule',
                          description: isTurkish
                            ? 'Her satırda 1\'den 9\'a kadar her sayı sadece bir kez bulunmalı.'
                            : 'Each row must contain numbers 1 to 9 only once.',
                          icon: Icons.linear_scale,
                          color: Colors.green,
                        ),

                        _SimpleRuleCard(
                          title: isTurkish ? 'Sütun Kuralı' : 'Column Rule',
                          description: isTurkish
                            ? 'Her sütunda 1\'den 9\'a kadar her sayı sadece bir kez bulunmalı.'
                            : 'Each column must contain numbers 1 to 9 only once.',
                          icon: Icons.view_week,
                          color: Colors.orange,
                        ),

                        _SimpleRuleCard(
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

                        const SizedBox(height: 24),

                        // YILDIZ SİSTEMİ - YENİ!
                        _TitleCard(
                          icon: Icons.star,
                          title: isTurkish ? 'YILDIZ SİSTEMİ ⭐' : 'STAR SYSTEM ⭐',
                           color: Colors.orange,
                        ),
                        const SizedBox(height: 16),

                        // 3 YILDIZ
                        _StarRequirementCard(
                          stars: 3,
                          title: isTurkish ? '3 YILDIZ 🏆' : '3 STARS 🏆',
                          requirements: isTurkish
                            ? [
                                '✅ Yüksek puan (zorluk bazlı)',
                                '✅ 0 HATA (ZORUNLU!)',
                                '✅ Hızlı bitirme',
                              ]
                            : [
                                '✅ High score (difficulty based)',
                                '✅ 0 MISTAKES (REQUIRED!)',
                                '✅ Fast completion',
                              ],
                          color: Colors.amber,
                        ),

                        // 2 YILDIZ
                        _StarRequirementCard(
                          stars: 2,
                          title: isTurkish ? '2 YILDIZ 👍' : '2 STARS 👍',
                          requirements: isTurkish
                            ? [
                                '✅ Orta seviye puan',
                                '⚠️ 1-2 hata yapabilirsiniz',
                                '⚠️ Biraz yavaş olabilir',
                              ]
                            : [
                                '✅ Medium score',
                                '⚠️ 1-2 mistakes allowed',
                                '⚠️ Can be slower',
                              ],
                          color: Colors.blue,
                        ),

                        // 1 YILDIZ
                        _StarRequirementCard(
                          stars: 1,
                          title: isTurkish ? '1 YILDIZ ✓' : '1 STAR ✓',
                          requirements: isTurkish
                            ? [
                                '✅ Leveli tamamladınız!',
                                '✅ Bir sonraki level açıldı',
                                '📝 Daha fazla yıldız için tekrar oynayın',
                              ]
                            : [
                                '✅ Level completed!',
                                '✅ Next level unlocked',
                                '📝 Replay for more stars',
                              ],
                          color: Colors.grey,
                        ),

                        const SizedBox(height: 24),

                        // Puan Sistemi
                        _TitleCard(
                          icon: Icons.emoji_events,
                          title: isTurkish ? 'PUAN SİSTEMİ 💯' : 'SCORING SYSTEM 💯',
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),


                        _ScoreCard(
                          icon: Icons.speed,
                          title: isTurkish ? 'Hız Bonusu (×5)' : 'Speed Bonus (×5)',
                          description: isTurkish
                            ? 'Her tasarruf edilen saniye = 5 puan! Yavaş bitirme = ceza (-2 puan/sn)'
                            : 'Each saved second = 5 points! Slow finish = penalty (-2 pts/sec)',
                        ),

                        _ScoreCard(
                          icon: Icons.check_circle,
                          title: isTurkish ? 'Hatasız Bonus' : 'No Mistake Bonus',
                          description: isTurkish
                            ? '0 hata: +800 puan! | 1 hata: +300 puan'
                            : '0 mistakes: +800 points! | 1 mistake: +300 points',
                        ),

                        _ScoreCard(
                          icon: Icons.lightbulb_outline,
                          title: isTurkish ? 'İpucusuz Bonus' : 'No Hint Bonus',
                          description: isTurkish
                            ? '0 ipucu: +500 puan! | 1 ipucu: +200 puan'
                            : '0 hints: +500 points! | 1 hint: +200 points',
                        ),

                        _ScoreCard(
                          icon: Icons.auto_awesome,
                          title: isTurkish ? 'Mükemmellik Bonusu!' : 'Perfection Bonus!',
                          description: isTurkish
                            ? '0 hata + 0 ipucu = +500 EKSTRA PUAN! 🏆'
                            : '0 mistakes + 0 hints = +500 EXTRA POINTS! 🏆',
                        ),

                        const SizedBox(height: 24),

                        // ÖNEMLİ NOTLAR
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red.shade200, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.warning_amber, color: Colors.red, size: 28),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      isTurkish ? '⚠️ ÖNEMLİ!' : '⚠️ IMPORTANT!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isTurkish
                                  ? '🏆 3 YILDIZ almak için 0 HATA ZORUNLU!\n\n'
                                    '✅ Yüksek puan + 0 Hata = 3 Yıldız\n'
                                    '⚠️ Yüksek puan + 1 Hata = Maksimum 2 Yıldız\n\n'
                                    'Mükemmellik için hata yapmayın! 💪'
                                  : '🏆 0 MISTAKES REQUIRED for 3 STARS!\n\n'
                                    '✅ High Score + 0 Mistakes = 3 Stars\n'
                                    '⚠️ High Score + 1 Mistake = Max 2 Stars\n\n'
                                    'Be perfect for perfection! 💪',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red.shade900,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

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
                                  ? 'Şimdi oynamaya başla ve 3 yıldız topla!' 
                                  : 'Start playing now and collect 3 stars!',
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

class _SimpleRuleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _SimpleRuleCard({
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
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

class _StarRequirementCard extends StatelessWidget {
  final int stars;
  final String title;
  final List<String> requirements;
  final Color color;

  const _StarRequirementCard({
    required this.stars,
    required this.title,
    required this.requirements,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(stars, (index) => Icon(Icons.star, color: color, size: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...requirements.map((req) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              req,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          )).toList(),
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

class _InfoBox extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const _InfoBox({
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
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
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}