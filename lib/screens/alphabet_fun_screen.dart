import 'dart:async';

import 'package:flutter/material.dart';

import '../models/alphabet_question.dart';
import '../models/game_result.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class AlphabetFunScreen extends StatefulWidget {
  final Student student;
  final AlphabetDifficulty difficulty;

  const AlphabetFunScreen({
    super.key,
    required this.student,
    required this.difficulty,
  });

  @override
  State<AlphabetFunScreen> createState() =>
      _AlphabetFunScreenState();
}

class _AlphabetFunScreenState
    extends State<AlphabetFunScreen> {
  static const int _totalQuestions = 10;

  late AlphabetDifficulty _difficulty;

  AlphabetQuestion? _currentQuestion;

  int _question = 0;
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
    _currentQuestion = AlphabetQuestion.generate(
      difficulty: _difficulty,
    );

    _selectedAnswer = null;
    _answered = false;
    _celebrating = false;
  }

  void _selectAnswer(String answer) {
    if (_answered || _currentQuestion == null) {
      return;
    }

    final question = _currentQuestion!;

    final bool isCorrect =
        answer == question.letter;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;

      if (isCorrect) {
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

    Future.delayed(
      const Duration(milliseconds: 900),
          () {
        if (!mounted) {
          return;
        }

        if (_question + 1 >= _totalQuestions) {
          _finishGame();
          return;
        }

        setState(() {
          _question++;
          _generateQuestion();
        });
      },
    );
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
      gameId: 'alphabet_fun',
      gameName: 'Alphabet Fun',
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

  String _difficultyTitle() {
    switch (_difficulty) {
      case AlphabetDifficulty.easy:
        return 'Easy';

      case AlphabetDifficulty.medium:
        return 'Medium';

      case AlphabetDifficulty.hard:
        return 'Hard';
    }
  }

  Color _optionColor(String option) {
    if (!_answered) {
      return Colors.white;
    }

    if (option == _currentQuestion?.letter) {
      return const Color(0xFFD8F5E3);
    }

    if (option == _selectedAnswer) {
      return const Color(0xFFFFD6D6);
    }

    return Colors.white;
  }

  Color _optionBorderColor(String option) {
    if (!_answered) {
      return Colors.transparent;
    }

    if (option == _currentQuestion?.letter) {
      return const Color(0xFF55B87A);
    }

    if (option == _selectedAnswer) {
      return const Color(0xFFE57373);
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final question = _currentQuestion;

    if (question == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Alphabet Fun',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          if (_streak > 0)
            Padding(
              padding: const EdgeInsets.only(
                right: 18,
              ),
              child: Center(
                child: Row(
                  children: [
                    const Text(
                      '🔥',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_streak',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            15,
            20,
            30,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                children: [
                  _buildProgress(),

                  const SizedBox(height: 18),

                  _buildDifficultyBadge(),

                  const SizedBox(height: 18),

                  _buildQuestionCard(question),

                  const SizedBox(height: 22),

                  _buildOptions(question),

                  const SizedBox(height: 20),

                  if (_answered)
                    _buildFeedback(question),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    final progress =
        (_question + 1) / _totalQuestions;

    return Column(
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_question + 1} of $_totalQuestions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              '⭐ $_correct',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white,
            valueColor:
            const AlwaysStoppedAnimation<Color>(
              AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$_difficultyTitle Level',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppTheme.textLight,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
      AlphabetQuestion question,
      ) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFCDE8FF),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7CC4FF)
                .withValues(alpha: 0.25),
            blurRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            question.emoji,
            style: const TextStyle(
              fontSize: 65,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            question.word,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: AppTheme.textDark,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Which letter does it start with?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(
      AlphabetQuestion question,
      ) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: question.options.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final option = question.options[index];

        final bool isCorrect =
            option == question.letter;

        final bool isSelected =
            option == _selectedAnswer;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectAnswer(option),
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              decoration: BoxDecoration(
                color: _optionColor(option),
                borderRadius:
                BorderRadius.circular(24),
                border: Border.all(
                  color: _optionBorderColor(option),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.05,
                    ),
                    blurRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      option,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),

                    if (_answered &&
                        (isCorrect || isSelected))
                      const SizedBox(width: 8),

                    if (_answered && isCorrect)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF55B87A),
                        size: 25,
                      ),

                    if (_answered &&
                        isSelected &&
                        !isCorrect)
                      const Icon(
                        Icons.cancel_rounded,
                        color: Color(0xFFE57373),
                        size: 25,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedback(
      AlphabetQuestion question,
      ) {
    final bool correct =
        _selectedAnswer == question.letter;

    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 250,
      ),
      child: Container(
        key: ValueKey(
          '${_question}_$correct',
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: correct
              ? const Color(0xFFD8F5E3)
              : const Color(0xFFFFE1E1),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Text(
              correct ? '🎉 Great Job!' : '💡 Nice Try!',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              correct
                  ? '$_celebrationText'
                  : 'The correct answer is ${question.letter}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _celebrationText {
    if (_streak >= 3) {
      return 'Amazing! $_streak in a row! 🔥';
    }

    return 'That was correct! ⭐';
  }
}