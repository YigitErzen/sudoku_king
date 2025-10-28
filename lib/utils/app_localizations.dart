class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'SUDOKU QUEST',
      'subtitle': '500 Epic Levels',
      'play': 'PLAY',
      'progress': 'PROGRESS',
      'selectLevel': 'Select Level',
      'yourProgress': 'Your Progress',
      'totalScore': 'Total Score',
      'completed': 'Completed',
      'noLevelsCompleted': 'No levels completed yet',
      'level': 'Level',
      'score': 'Score',
      'mistakes': 'Mistakes',
      'hints': 'Hints',
      'hint': 'Hint',
      'congratulations': 'Congratulations!',
      'levelCompleted': 'Level completed!',
      'points': 'Points',
      'time': 'Time',
      'errors': 'Errors',
      'levelSelection': 'Level Selection',
      'nextLevel': 'Next Level',
      'gameOver': 'Game Over!',
      'threeErrors': 'You made 3 mistakes!',
      'levelFailed': 'Level failed.',
      'tryAgain': 'Try Again',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'expert': 'Expert',
    },
    'tr': {
      'title': 'SUDOKU QUEST',
      'subtitle': '500 Epik Seviye',
      'play': 'OYNA',
      'progress': 'İLERLEME',
      'selectLevel': 'Seviye Seç',
      'yourProgress': 'İlerlemeniz',
      'totalScore': 'Toplam Puan',
      'completed': 'Tamamlanan',
      'noLevelsCompleted': 'Henüz level tamamlamadınız',
      'level': 'Level',
      'score': 'Puan',
      'mistakes': 'Hata',
      'hints': 'İpucu',
      'hint': 'İpucu',
      'congratulations': 'Tebrikler!',
      'levelCompleted': 'tamamlandı!',
      'points': 'Puan',
      'time': 'Süre',
      'errors': 'Hatalar',
      'levelSelection': 'Level Seçimi',
      'nextLevel': 'Sonraki Level',
      'gameOver': 'Oyun Bitti!',
      'threeErrors': '3 hata yaptınız!',
      'levelFailed': 'başarısız.',
      'tryAgain': 'Tekrar Dene',
      'easy': 'Kolay',
      'medium': 'Orta',
      'hard': 'Zor',
      'expert': 'Uzman',
    },
  };

  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}