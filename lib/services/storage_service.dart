import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Level puanını kaydet
  static Future<void> saveLevelScore(int level, int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level_${level}_score', score);
  }

  // Level süresini kaydet
  static Future<void> saveLevelTime(int level, int timeInSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level_${level}_time', timeInSeconds);
  }

  // Level puanını al
  static Future<int?> getLevelScore(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('level_${level}_score');
  }

  // Level süresini al
  static Future<int?> getLevelTime(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('level_${level}_time');
  }

  // Açık leveli kaydet
  static Future<void> saveUnlockedLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unlockedLevel', level);
  }

  // Açık leveli al
  static Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('unlockedLevel') ?? 1;
  }

  // Tüm level puanlarını al
  static Future<Map<int, int>> getAllLevelScores() async {
    final prefs = await SharedPreferences.getInstance();
    Map<int, int> scores = {};
    
    for (int i = 1; i <= 500; i++) {
      int? score = prefs.getInt('level_${i}_score');
      if (score != null) {
        scores[i] = score;
      }
    }
    
    return scores;
  }

  // Tüm level sürelerini al
  static Future<Map<int, int>> getAllLevelTimes() async {
    final prefs = await SharedPreferences.getInstance();
    Map<int, int> times = {};
    
    for (int i = 1; i <= 500; i++) {
      int? time = prefs.getInt('level_${i}_time');
      if (time != null) {
        times[i] = time;
      }
    }
    
    return times;
  }

  // Yıldız kaydet
  static Future<void> saveLevelStars(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level_${level}_stars', stars);
  }

  // Yıldız al
  static Future<int?> getLevelStars(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('level_${level}_stars');
  }

  // Tüm yıldızları al
  static Future<Map<int, int>> getAllLevelStars() async {
    final prefs = await SharedPreferences.getInstance();
    Map<int, int> stars = {};
    
    for (int i = 1; i <= 500; i++) {
      int? star = prefs.getInt('level_${i}_stars');
      if (star != null) {
        stars[i] = star;
      }
    }
    
    return stars;
  }
}