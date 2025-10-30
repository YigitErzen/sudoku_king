import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_localizations.dart';
import '../services/storage_service.dart';
import '../widgets/stat_box.dart';
import '../widgets/number_button.dart';
import '../widgets/action_button.dart';
import '../widgets/stars_display.dart';

class SudokuGameScreen extends StatefulWidget {
  final int level;
  final String difficulty;
  final String currentLanguage;

  const SudokuGameScreen({
    super.key,
    required this.level,
    required this.difficulty,
    required this.currentLanguage,
  });

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  late List<List<int>> board;
  late List<List<int>> solution;
  late List<List<bool>> editable;
  late List<List<bool>> isCorrect;
  late List<List<bool>> isHint;
  int selectedRow = -1;
  int selectedCol = -1;
  int score = 0;
  int mistakes = 0;
  int hintsUsed = 0;
  int extraHints = 0;
  late DateTime startTime;
  bool gameOver = false;
  bool gameWon = false;
  late Random _random;
  
  Timer? _timer;
  String _elapsedTime = "00:00";

  Color get difficultyColor {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy':
      case 'kolay':
        return Colors.green;
      case 'medium':
      case 'orta':
        return Colors.orange;
      case 'hard':
      case 'zor':
        return Colors.red;
      case 'expert':
      case 'uzman':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  int get emptyCells {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy':
      case 'kolay':
        return 35;
      case 'medium':
      case 'orta':
        return 45;
      case 'hard':
      case 'zor':
        return 52;
      case 'expert':
      case 'uzman':
        return 58;
      default:
        return 40;
    }
  }

  int get totalHints => (1 - hintsUsed) + extraHints;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _random = Random(widget.level);
    startTime = DateTime.now();
    _generatePuzzle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!gameOver) {
        setState(() {
          Duration elapsed = DateTime.now().difference(startTime);
          int minutes = elapsed.inMinutes;
          int seconds = elapsed.inSeconds % 60;
          _elapsedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        });
      }
    });
  }

  void _generatePuzzle() {
    solution = _generateCompleteSudoku();
    board = solution.map((row) => List<int>.from(row)).toList();
    editable = List.generate(9, (_) => List.generate(9, (_) => false));
    isCorrect = List.generate(9, (_) => List.generate(9, (_) => true));
    isHint = List.generate(9, (_) => List.generate(9, (_) => false));

    _removeNumbers();
  }

  List<List<int>> _generateCompleteSudoku() {
    List<List<int>> grid = List.generate(9, (_) => List.filled(9, 0));
    
    // Önce diagonal 3x3 kutularını doldur (bunlar birbirinden bağımsız)
    for (int box = 0; box < 3; box++) {
      _fillBox(grid, box * 3, box * 3);
    }
    
    // Sonra kalan hücreleri çöz
    _solveSudoku(grid);
    return grid;
  }

  // 3x3 kutuyu rastgele sayılarla doldur
  void _fillBox(List<List<int>> grid, int startRow, int startCol) {
    List<int> nums = List.generate(9, (i) => i + 1);
    nums.shuffle(_random);
    
    int index = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        grid[startRow + i][startCol + j] = nums[index++];
      }
    }
  }

  bool _solveSudoku(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          // Sayıları rastgele dene (her puzzle farklı olsun)
          List<int> numbers = List.generate(9, (i) => i + 1);
          numbers.shuffle(_random);
          
          for (int num in numbers) {
            if (_isValidMove(grid, row, col, num)) {
              grid[row][col] = num;
              if (_solveSudoku(grid)) return true;
              grid[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool _isValidMove(List<List<int>> grid, int row, int col, int num) {
    // Satır kontrolü
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == num) return false;
    }
    
    // Sütun kontrolü
    for (int i = 0; i < 9; i++) {
      if (grid[i][col] == num) return false;
    }
    
    // 3x3 kutu kontrolü
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[startRow + i][startCol + j] == num) return false;
      }
    }
    
    return true;
  }

  void _removeNumbers() {
    int cellsToRemove = emptyCells;
    List<List<int>> positions = [];
    
    // Tüm pozisyonları listeye ekle
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        positions.add([i, j]);
      }
    }
    
    // Pozisyonları karıştır
    positions.shuffle(_random);
    
    // Rastgele pozisyonlardan sayıları çıkar
    for (int i = 0; i < cellsToRemove && i < positions.length; i++) {
      int row = positions[i][0];
      int col = positions[i][1];
      board[row][col] = 0;
      editable[row][col] = true;
    }
  }

  void _selectCell(int row, int col) {
    if (!gameOver && editable[row][col]) {
      setState(() {
        selectedRow = row;
        selectedCol = col;
      });
    }
  }

  void _placeNumber(int number) {
    if (selectedRow != -1 && selectedCol != -1 && !gameOver) {
      setState(() {
        board[selectedRow][selectedCol] = number;
        
        if (solution[selectedRow][selectedCol] == number) {
          isCorrect[selectedRow][selectedCol] = true;
          int basePoints = _calculateBasePoints(selectedRow, selectedCol);
          score += basePoints;
        } else {
          isCorrect[selectedRow][selectedCol] = false;
          mistakes++;
          
          if (mistakes >= 3) {
            _showWatchAdForExtraLifeDialog();
            return;
          }
        }

        if (_isPuzzleComplete()) {
          gameOver = true;
          gameWon = true;
          _timer?.cancel();
          _calculateFinalScore();
          _saveProgress();
          _showVictoryDialog();
        }
      });
    }
  }

  int _calculateBasePoints(int row, int col) {
    int possibilities = 0;
    for (int num = 1; num <= 9; num++) {
      if (_isValidMove(board, row, col, num)) {
        possibilities++;
      }
    }
    
    int difficultyMultiplier = switch (widget.difficulty.toLowerCase()) {
      'easy' || 'kolay' => 1,
      'medium' || 'orta' => 2,
      'hard' || 'zor' => 3,
      'expert' || 'uzman' => 5,
      _ => 1,
    };
    
    int basePoints = (10 - possibilities) * 10 * difficultyMultiplier;
    return basePoints.clamp(10, 200);
  }

  void _calculateFinalScore() {
    Duration elapsed = DateTime.now().difference(startTime);
    int timeInSeconds = elapsed.inSeconds;
    
    int difficultyMultiplier = switch (widget.difficulty.toLowerCase()) {
      'easy' || 'kolay' => 100,
      'medium' || 'orta' => 150,
      'hard' || 'zor' => 200,
      'expert' || 'uzman' => 250,
      _ => 150,
    };
    
    score = difficultyMultiplier;
    
    int targetTime = switch (widget.difficulty.toLowerCase()) {
      'easy' || 'kolay' => 180,
      'medium' || 'orta' => 300,
      'hard' || 'zor' => 480,
      'expert' || 'uzman' => 600,
      _ => 300,
    };
    
    if (timeInSeconds < targetTime) {
      int timeBonus = ((targetTime - timeInSeconds) * 5).round();
      score += timeBonus;
    } else {
      int penalty = ((timeInSeconds - targetTime) * 2).round();
      score = (score - penalty).clamp(50, score);
    }
    
    if (mistakes == 0) {
      score += 800;
    } else if (mistakes == 1) {
      score += 300;
    }
    
    if (hintsUsed == 0) {
      score += 500;
    } else if (hintsUsed == 1) {
      score += 200;
    }
    
    if (mistakes == 0 && hintsUsed == 0) {
      score += 500;
    }
    
    score = score.clamp(50, 10000);
  }

  int _calculateStars() {
    Map<String, List<int>> starLimits = {
      'easy': [500, 1000],
      'kolay': [500, 1000],
      'medium': [800, 1500],
      'orta': [800, 1500],
      'hard': [1000, 2000],
      'zor': [1000, 2000],
      'expert': [1500, 2500],
      'uzman': [1500, 2500],
    };

    List<int> limits = starLimits[widget.difficulty.toLowerCase()] ?? [800, 1500];

    if (score >= limits[1] && mistakes == 0) {
      return 3;
    }
    
    if (score >= limits[0]) {
      return 2;
    }
    
    return 1;
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    Duration elapsed = DateTime.now().difference(startTime);
    int timeInSeconds = elapsed.inSeconds;
    
    int? existingScore = prefs.getInt('level_${widget.level}_score');
    
    if (existingScore == null || score > existingScore) {
      await prefs.setInt('level_${widget.level}_score', score);
      await prefs.setInt('level_${widget.level}_time', timeInSeconds);
      
      int stars = _calculateStars();
      await StorageService.saveLevelStars(widget.level, stars);
    }
    
    int currentUnlocked = prefs.getInt('unlockedLevel') ?? 1;
    if (widget.level >= currentUnlocked && widget.level < 500) {
      await prefs.setInt('unlockedLevel', widget.level + 1);
    }
  }

  void _useHint() {
    if (totalHints > 0 && selectedRow != -1 && selectedCol != -1 && !gameOver) {
      if (editable[selectedRow][selectedCol]) {
        setState(() {
          board[selectedRow][selectedCol] = solution[selectedRow][selectedCol];
          isCorrect[selectedRow][selectedCol] = true;
          isHint[selectedRow][selectedCol] = true;
          editable[selectedRow][selectedCol] = false;
          
          if (hintsUsed < 1) {
            hintsUsed++;
          } else {
            extraHints--;
          }
          
          score = (score - 50).clamp(0, 999999);
        });

        if (_isPuzzleComplete()) {
          gameOver = true;
          gameWon = true;
          _timer?.cancel();
          _calculateFinalScore();
          _saveProgress();
          _showVictoryDialog();
        }
      }
    } else if (!gameOver) {
      _showWatchAdForHintDialog();
    }
  }

  void _showWatchAdForHintDialog() {
    final bool isTurkish = widget.currentLanguage == 'tr';
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 60,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            Text(
              isTurkish ? 'İpucu Hakkı Bitti!' : 'No Hints Left!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200, width: 2),
              ),
              child: Column(
                children: [
                  Icon(Icons.video_library, size: 48, color: Colors.amber.shade700),
                  const SizedBox(height: 12),
                  Text(
                    isTurkish 
                        ? 'Reklam izleyerek\n+1 ipucu kazanabilirsin!' 
                        : 'Watch an ad to earn\n+1 hint!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.play_circle_fill, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isTurkish 
                        ? '~ 30 saniye reklam' 
                        : '~ 30 second ad',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isTurkish ? 'İptal' : 'Cancel',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _watchAdForHint();
            },
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            label: Text(
              isTurkish ? 'Reklam İzle' : 'Watch Ad',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWatchAdForExtraLifeDialog() {
    final bool isTurkish = widget.currentLanguage == 'tr';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(
              Icons.favorite_border,
              size: 60,
              color: Colors.pink,
            ),
            const SizedBox(height: 16),
            Text(
              isTurkish ? '💔 3 Hata Yaptınız!' : '💔 3 Mistakes Made!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.shade200, width: 2),
              ),
              child: Column(
                children: [
                  Icon(Icons.video_library, size: 48, color: Colors.pink.shade700),
                  const SizedBox(height: 12),
                  Text(
                    isTurkish 
                        ? 'Reklam izleyerek\n+1 CAN kazanabilirsin!' 
                        : 'Watch an ad to earn\n+1 EXTRA LIFE!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isTurkish 
                          ? '🎮 Oyuna devam edebilirsin!' 
                          : '🎮 Continue playing!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.play_circle_fill, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isTurkish 
                        ? '~ 30 saniye reklam' 
                        : '~ 30 second ad',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                gameOver = true;
                gameWon = false;
              });
              _showGameOverDialog();
            },
            child: Text(
              isTurkish ? 'Hayır, Bitir' : 'No, End Game',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _watchAdForExtraLife();
            },
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            label: Text(
              isTurkish ? 'Reklam İzle' : 'Watch Ad',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _watchAdForHint() async {
    final bool isTurkish = widget.currentLanguage == 'tr';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              isTurkish ? 'Reklam yükleniyor...' : 'Loading ad...',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      extraHints++;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isTurkish 
                      ? '🎉 +1 İpucu Kazandınız!' 
                      : '🎉 +1 Hint Earned!',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _watchAdForExtraLife() async {
    final bool isTurkish = widget.currentLanguage == 'tr';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.pink),
            const SizedBox(height: 20),
            Text(
              isTurkish ? 'Reklam yükleniyor...' : 'Loading ad...',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      mistakes--;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.favorite, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isTurkish 
                      ? '💖 +1 Ekstra Can Kazandınız! Oyun Devam Ediyor!' 
                      : '💖 +1 Extra Life Earned! Game Continues!',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.pink,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  bool _isPuzzleComplete() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0 || board[i][j] != solution[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  void _showVictoryDialog() {
    final local = AppLocalizations(widget.currentLanguage);
    Duration elapsed = DateTime.now().difference(startTime);
    int minutes = elapsed.inMinutes;
    int seconds = elapsed.inSeconds % 60;
    int stars = _calculateStars();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Text(
              '${local.translate('level')} ${widget.level}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: difficultyColor,
              ),
            ),
            const SizedBox(height: 20),
            BigStarsDisplay(stars: stars),
            const SizedBox(height: 20),
            Text(
              local.translate('congratulations'),
              style: TextStyle(
                color: difficultyColor, 
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: difficultyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${local.translate('score').toUpperCase()}:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: difficultyColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${local.translate('time')}:', style: TextStyle(fontSize: 14)),
                      Text('${minutes}m ${seconds}s', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${local.translate('errors')}:', style: TextStyle(fontSize: 14)),
                      Text('$mistakes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${local.translate('hints')}:', style: TextStyle(fontSize: 14)),
                      Text('$hintsUsed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: Text(local.translate('levelSelection'), style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: difficultyColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (widget.level < 500) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SudokuGameScreen(
                      level: widget.level + 1,
                      difficulty: _getDifficultyLabel(widget.level + 1),
                      currentLanguage: widget.currentLanguage,
                    ),
                  ),
                );
              } else {
                Navigator.pop(context, true);
              }
            },
            child: Text(
              local.translate('nextLevel'), 
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyLabel(int level) {
    final local = AppLocalizations(widget.currentLanguage);
    if (level <= 125) return local.translate('easy');
    if (level <= 250) return local.translate('medium');
    if (level <= 375) return local.translate('hard');
    return local.translate('expert');
  }

  void _showGameOverDialog() {
    final local = AppLocalizations(widget.currentLanguage);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(Icons.cancel, size: 60, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              local.translate('gameOver'),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(local.translate('threeErrors'), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text('${local.translate('level')} ${widget.level} ${local.translate('levelFailed')}', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, false);
            },
            child: Text(local.translate('levelSelection'), style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: difficultyColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SudokuGameScreen(
                    level: widget.level,
                    difficulty: widget.difficulty,
                    currentLanguage: widget.currentLanguage,
                  ),
                ),
              );
            },
            child: Text(local.translate('tryAgain'), style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final local = AppLocalizations(widget.currentLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text('${local.translate('level')} ${widget.level}'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [difficultyColor, difficultyColor.withOpacity(0.7)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [difficultyColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatBox(label: widget.currentLanguage == 'tr' ? 'Süre' : 'Time', value: _elapsedTime, icon: Icons.timer),
                  StatBox(label: local.translate('mistakes'), value: '$mistakes/3', icon: Icons.close),
                  StatBox(label: local.translate('hints'), value: '$totalHints', icon: Icons.lightbulb),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: difficultyColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 9,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: 81,
                      itemBuilder: (context, index) {
                        int row = index ~/ 9;
                        int col = index % 9;
                        bool isSelected = selectedRow == row && selectedCol == col;
                        bool isEditable = editable[row][col];
                        int value = board[row][col];
                        bool isCorrectValue = isCorrect[row][col];
                        bool isHintCell = isHint[row][col];

                        Color textColor;
                        if (isHintCell) {
                          textColor = Colors.amber.shade700;
                        } else if (isEditable && value != 0) {
                          textColor = isCorrectValue ? Colors.green : Colors.red;
                        } else {
                          textColor = Colors.black87;
                        }

                        return GestureDetector(
                          onTap: () => _selectCell(row, col),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? difficultyColor.withOpacity(0.3)
                                  : (row ~/ 3) % 2 == (col ~/ 3) % 2
                                      ? Colors.grey.shade100
                                      : Colors.white,
                              border: Border.all(
                                color: isSelected ? difficultyColor : Colors.grey.shade300,
                                width: isSelected ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                value == 0 ? '' : '$value',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (i) => NumberButton(number: i + 1, onTap: _placeNumber)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...List.generate(4, (i) => NumberButton(number: i + 6, onTap: _placeNumber)),
                      ActionButton(
                        icon: Icons.lightbulb_outline,
                        label: local.translate('hint'),
                        color: Colors.amber,
                        onTap: _useHint,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}