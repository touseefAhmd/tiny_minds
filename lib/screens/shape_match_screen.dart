import 'dart:async';

import 'package:flutter/material.dart';

import '../models/game_result.dart';
import '../models/shape_question.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import 'result_screen.dart';

class ShapeMatchScreen extends StatefulWidget {
  final Student student;
  final ShapeDifficulty difficulty;

  const ShapeMatchScreen({
    super.key,
    required this.student,
    required this.difficulty,
  });

  @override
  State<ShapeMatchScreen> createState() =>
      _ShapeMatchScreenState();
}

class _ShapeMatchScreenState
    extends State<ShapeMatchScreen> {
  static const int _totalQuestions = 10;

  late ShapeDifficulty _difficulty;

  ShapeQuestion? _question;

  int _currentQuestion = 1;
  int _correct = 0;
  int _wrong = 0;
  int _streak = 0;
  int _bestStreak = 0;

  bool _answered = false;
  bool _celebrating = false;

  String? _selectedAnswer;

  late DateTime _startedAt;

  @override
  void initState() {
    super.initState();

    _difficulty = widget.difficulty;
    _startedAt = DateTime.now();

    _generateQuestion();
  }

  void _generateQuestion() {
    _question = ShapeQuestion.generate(
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

      if (answer == question.displayName) {
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
      gameId: 'shape_match',
      gameName: 'Shape Match',
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

    if (option == _question!.displayName) {
      return const Color(0xFFD9F7E3);
    }

    if (option == _selectedAnswer) {
      return const Color(0xFFFFD9D9);
    }

    return Colors.white;
  }

  Color _getOptionBorderColor(String option) {
    if (!_answered) {
      return Colors.grey.shade300;
    }

    if (_question == null) {
      return Colors.grey.shade300;
    }

    if (option == _question!.displayName) {
      return Colors.green;
    }

    if (option == _selectedAnswer) {
      return Colors.red;
    }

    return Colors.grey.shade300;
  }

  String _difficultyTitle() {
    switch (_difficulty) {
      case ShapeDifficulty.easy:
        return 'Easy';

      case ShapeDifficulty.medium:
        return 'Medium';

      case ShapeDifficulty.hard:
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
        title: const Text('🔷 Shape Match'),
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
                      color: const Color(0xFFE8E0FF),
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
                              'What shape is this?',
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
                                          fontSize: 20,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    if (_answered &&
                                        option ==
                                            question
                                                .displayName)
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
                                            question
                                                .displayName)
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
                          ? const SizedBox(
                        height: 30,
                      )
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