import 'package:flutter/material.dart';

import '../models/animal_question.dart';
import '../models/game_result.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import 'result_screen.dart';

class AnimalMatchScreen extends StatefulWidget {
  final Student student;
  final AnimalDifficulty difficulty;

  const AnimalMatchScreen({
    super.key,
    required this.student,
    required this.difficulty,
  });

  @override
  State<AnimalMatchScreen> createState() =>
      _AnimalMatchScreenState();
}

class _AnimalMatchScreenState
    extends State<AnimalMatchScreen> {
  static const int _totalQuestions = 10;

  late AnimalDifficulty _difficulty;
  late DateTime _startedAt;

  AnimalQuestion? _question;

  int _currentQuestion = 1;
  int _correct = 0;
  int _wrong = 0;
  int _streak = 0;
  int _bestStreak = 0;

  bool _answered = false;
  bool _celebrating = false;

  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();

    _difficulty = widget.difficulty;
    _startedAt = DateTime.now();

    _generateQuestion();
  }

  void _generateQuestion() {
    _question = AnimalQuestion.generate(
      difficulty: _difficulty,
    );
  }

  Future<void> _selectAnswer(String answer) async {
    if (_answered || _question == null) {
      return;
    }

    final question = _question!;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;

      if (answer == question.animal) {
        _correct++;
        _streak++;

        if (_streak > _bestStreak) {
          _bestStreak = _streak;
        }

        _celebrating = true;
      } else {
        _wrong++;
        _streak = 0;
        _celebrating = false;
      }
    });

    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    if (!mounted) {
      return;
    }

    if (_currentQuestion >= _totalQuestions) {
      await _finishGame();
      return;
    }

    setState(() {
      _currentQuestion++;
      _answered = false;
      _selectedAnswer = null;
      _celebrating = false;

      _generateQuestion();
    });
  }

  Future<void> _finishGame() async {
    final duration =
    DateTime.now().difference(_startedAt);

    final result = GameResult(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      studentId: widget.student.id,
      studentName: widget.student.name,
      gameId: 'animal_match',
      gameName: 'Animal Match',
      score: _correct,
      totalQuestions: _totalQuestions,
      correctAnswers: _correct,
      wrongAnswers: _wrong,
      durationSeconds: duration.inSeconds,
      playedAt: DateTime.now(),
    );

    await StorageService.saveGameResult(result);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          result: result,
        ),
      ),
    );
  }

  Color _getOptionColor(String option) {
    if (!_answered) {
      return Colors.white;
    }

    if (_question == null) {
      return Colors.white;
    }

    if (option == _question!.animal) {
      return const Color(0xFFD9F7E3);
    }

    if (option == _selectedAnswer) {
      return const Color(0xFFFFD9D9);
    }

    return Colors.white;
  }

  Color _getOptionBorderColor(String option) {
    if (!_answered || _question == null) {
      return Colors.grey.shade300;
    }

    if (option == _question!.animal) {
      return Colors.green;
    }

    if (option == _selectedAnswer) {
      return Colors.red;
    }

    return Colors.grey.shade300;
  }

  String _difficultyTitle() {
    switch (_difficulty) {
      case AnimalDifficulty.easy:
        return 'Easy';

      case AnimalDifficulty.medium:
        return 'Medium';

      case AnimalDifficulty.hard:
        return 'Hard';
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;

    if (question == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final progress =
        _currentQuestion / _totalQuestions;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF3),
      appBar: AppBar(
        title: const Text('🐾 Animal Match'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '⭐ $_correct',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Question $_currentQuestion/$_totalQuestions',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8C8),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      _difficultyTitle(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 9,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Column(
                  children: [
                    AnimatedScale(
                      scale: _celebrating ? 1.08 : 1.0,
                      duration:
                      const Duration(milliseconds: 250),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 28,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              question.emoji,
                              style: const TextStyle(
                                fontSize: 90,
                              ),
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              'Which animal is this?',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Choose the correct answer',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Expanded(
                      child: GridView.builder(
                        physics:
                        const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.7,
                        ),
                        itemCount: question.options.length,
                        itemBuilder: (context, index) {
                          final option =
                          question.options[index];

                          return InkWell(
                            borderRadius:
                            BorderRadius.circular(18),
                            onTap: _answered
                                ? null
                                : () => _selectAnswer(
                              option,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 200,
                              ),
                              decoration: BoxDecoration(
                                color: _getOptionColor(
                                  option,
                                ),
                                borderRadius:
                                BorderRadius.circular(18),
                                border: Border.all(
                                  color:
                                  _getOptionBorderColor(
                                    option,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        option,
                                        textAlign:
                                        TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    if (_answered &&
                                        option ==
                                            question.animal)
                                      const Padding(
                                        padding:
                                        EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                      ),

                                    if (_answered &&
                                        option ==
                                            _selectedAnswer &&
                                        option !=
                                            question.animal)
                                      const Padding(
                                        padding:
                                        EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
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

                    const SizedBox(height: 12),

                    AnimatedSwitcher(
                      duration:
                      const Duration(milliseconds: 200),
                      child: !_answered
                          ? const SizedBox(height: 30)
                          : Text(
                        _celebrating
                            ? '🎉 Great job! Streak: $_streak'
                            : '💪 Keep trying!',
                        key: ValueKey(
                          _celebrating,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _celebrating
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}