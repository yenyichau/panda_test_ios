import 'dart:math';

import 'package:intl/intl.dart';

import '../imports.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String difficulty = "Easy";
  int score = 0;
  bool gameStarted = false;
  late Timer timer;
  int timeLeft = 30;
  Offset targetPosition = const Offset(100, 100);
  final Random random = Random();

  Duration targetMoveDuration = const Duration(milliseconds: 800);
  List<Map<String, dynamic>> scoreHistory = [];

  @override
  void initState() {
    super.initState();

    _loadScoreHistory();
  }

  void startGame(String dif) {
    setState(() {
      score = 0;
      timeLeft = 30;
      gameStarted = true;
      difficulty = dif;

      // Adjust target speed based on difficulty
      switch (difficulty) {
        case 'Easy':
          targetMoveDuration = const Duration(milliseconds: 1200);

          break;
        case 'Medium':
          targetMoveDuration = const Duration(milliseconds: 800);

          break;
        case 'Hard':
          targetMoveDuration = const Duration(milliseconds: 400);

          break;
      }
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          finishGame();
        }
      });
    });

    moveTarget();
  }

  void moveTarget() {
    Timer.periodic(targetMoveDuration, (timer) {
      if (!gameStarted) {
        timer.cancel();
      } else {
        setState(() {
          targetPosition = Offset(
            random.nextDouble() * (AppSize.width - 50.fw),
            random.nextDouble() * (AppSize.height - 200.fh),
          );
        });
      }
    });
  }

  void finishGame() async {
    await _saveScore();

    setState(() {
      score = 0;
      timeLeft = 30;
      gameStarted = false;
    });
    if (timer.isActive) {
      timer.cancel();
    }
  }

  void onTargetTapped() {
    if (gameStarted) {
      setState(() {
        score++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        text: 'TapChallenge',
        centerTitle: true,
        actions: [
          if (gameStarted)
            Center(
              child: SizedBox(
                height: kToolbarHeight.fh,
                child: InkWellWrapper(
                  onTap: finishGame,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: kHorizontalPadding)
                        .r,
                    child: const Center(
                      child: AppText(
                        "Finish",
                        fontSize: kFont14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding,
                      vertical: kHorizontalPadding)
                  .r,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: AppText(
                        'Score: $score',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AppText(
                        'Time: $timeLeft',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  if (gameStarted)
                    Positioned(
                      top: targetPosition.dy,
                      left: targetPosition.dx,
                      child: GestureDetector(
                        onTap: onTargetTapped,
                        child: Container(
                          width: 50.fh,
                          height: 50.fh,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  if (!gameStarted)
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                                horizontal: AppSize.width * 0.1)
                            .r,
                        padding: const EdgeInsets.all(kHorizontalPadding).r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(10).r,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppText(
                              'Select a difficulty to start:',
                            ),
                            const SizedBox(height: 20),
                            AppButton(
                              onTap: () => startGame("Easy"),
                              text: "Easy",
                              buttonColor: Colors.green.withOpacity(0.2),
                            ),
                            10.heightSpace,
                            AppButton(
                              onTap: () => startGame("Medium"),
                              text: "Medium",
                              buttonColor: Colors.yellow.withOpacity(0.2),
                            ),
                            10.heightSpace,
                            AppButton(
                              onTap: () => startGame("Hard"),
                              text: "Hard",
                              buttonColor: Colors.red.withOpacity(0.2),
                            ),
                            50.heightSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButton(
                                  onTap: _showHistoryDialog,
                                  text: "Check History",
                                  textSize: kFont12,
                                  borderColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: kHorizontalPadding,
                                          vertical: 5)
                                      .r,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const AppText('Score History'),
          content: scoreHistory.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20).r,
                  child: const AppText('No history available.'),
                )
              : SizedBox(
                  height: AppSize.height * 0.6,
                  width: AppSize.width * 0.7,
                  child: ListView.separated(
                    itemCount: scoreHistory.length,
                    itemBuilder: (context, index) {
                      final entry = scoreHistory[index];
                      final date = DateTime.parse(entry['date']);
                      final formattedDate = DateFormat('yyyy-MM-dd, h:mma')
                          .format(date)
                          .toLowerCase();
                      return ListTile(
                        title: AppText(
                          '${entry['difficulty']} - Score: ${entry['score']}',
                        ),
                        subtitle: AppText(
                          formattedDate,
                          color: Colors.grey,
                          fontSize: kFont12,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10).r,
                        child: 1.dividerHorizontal,
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const AppText('Close'),
            ),
            TextButton(
              onPressed: _clearScores,
              child: const AppText(
                'Clear History',
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String date = DateTime.now().toIso8601String();
    final Map<String, dynamic> entry = {
      'date': date,
      'score': score,
      'difficulty': difficulty,
    };

    scoreHistory.insert(0, entry);

    // Save to shared preferences
    await prefs.setString('scoreHistory', jsonEncode(scoreHistory));
  }

  Future<void> _loadScoreHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedScores = prefs.getString('scoreHistory');
    if (savedScores != null) {
      setState(() {
        scoreHistory = List<Map<String, dynamic>>.from(jsonDecode(savedScores));
        // Sort by date in descending order
        scoreHistory.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA); // Latest date first
        });
      });
    }
  }

  void _clearScores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('scoreHistory');
    scoreHistory.clear();

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
