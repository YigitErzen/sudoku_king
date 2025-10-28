class StarService {
  // Puana göre yıldız sayısını hesapla
  static int getStarsForScore(int score, String difficulty) {
    // Zorluk seviyesine göre farklı limitler
    Map<String, List<int>> starLimits = {
      'easy': [300, 600],      // Kolay: 300+ = 2 yıldız, 600+ = 3 yıldız
      'kolay': [300, 600],
      'medium': [500, 1000],   // Orta: 500+ = 2 yıldız, 1000+ = 3 yıldız
      'orta': [500, 1000],
      'hard': [700, 1400],     // Zor: 700+ = 2 yıldız, 1400+ = 3 yıldız
      'zor': [700, 1400],
      'expert': [1000, 2000],  // Uzman: 1000+ = 2 yıldız, 2000+ = 3 yıldız
      'uzman': [1000, 2000],
    };

    List<int> limits = starLimits[difficulty.toLowerCase()] ?? [500, 1000];

    if (score >= limits[1]) return 3; // 3 Yıldız
    if (score >= limits[0]) return 2; // 2 Yıldız
    return 1; // 1 Yıldız
  }

  // Yıldızları kaydet
  static Future<void> saveStars(int level, int stars) async {
    // SharedPreferences ile kaydetme işlemi storage_service'e eklenecek
  }
}