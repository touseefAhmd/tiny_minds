import 'dart:async';

import 'package:flutter/material.dart';

import '../models/game_result.dart';
import '../models/number_question.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class NumberFunScreen extends StatefulWidget {
  final Student student;
  final NumberDifficulty difficulty;

  const NumberFunScreen({
    super.key,
    required this.student,
    required this.difficulty
  });

  @override
  State<NumberFunScreen> createState() => _NumberFunScreenState();
}

class _NumberFunScreenState extends State<NumberFunScreen>
    with SingleTickerProviderStateMixin {
  static const int totalQuestions = 10;

  late AnimationController _animationController;

  late NumberDifficulty _difficulty;

  NumberQuestion? _currentQuestion;

  int _question = 1;
  int _correct = 0;
  int _wrong = 0;
  int _streak = 0;
  int _bestStreak = 0;

  bool _answered = false;
  bool _celebrating = false;

  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _difficulty = widget.difficulty;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _generateQuestion();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    _currentQuestion = NumberQuestion.generate(
      difficulty: _difficulty,
    );

    _animationController.forward(from: 0);
  }

  void _startGame(NumberDifficulty difficulty) {
    setState(() {
      _difficulty = difficulty;
      _question = 1;
      _correct = 0;
      _wrong = 0;
      _streak = 0;
      _bestStreak = 0;
      _answered = false;
      _celebrating = false;
      _startedAt = DateTime.now();
    });

    _generateQuestion();
  }

  Future<void> _selectAnswer(int answer) async {
    if (_answered || _currentQuestion == null) {
      return;
    }

    final correctAnswer =
        _currentQuestion!.correctAnswer;

    final bool isCorrect = answer == correctAnswer;

    setState(() {
      _answered = true;

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

    await Future.delayed(
      Duration(
        milliseconds: isCorrect ? 800 : 1100,
      ),
    );

    if (!mounted) return;

    if (_question >= totalQuestions) {
      await _finishGame();
      return;
    }

    setState(() {
      _question++;
      _answered = false;
      _celebrating = false;
    });

    _generateQuestion();
  }

  Future<void> _finishGame() async {
    final duration = DateTime.now().difference(
      _startedAt ?? DateTime.now(),
    );

    final result = GameResult(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      studentId: widget.student.id,
      studentName: widget.student.name,
      gameId: 'number_fun',
      gameName: 'Number Fun',
      score: _correct,
      totalQuestions: totalQuestions,
      correctAnswers: _correct,
      wrongAnswers: _wrong,
      durationSeconds: duration.inSeconds,
      playedAt: DateTime.now(),
    );

    await StorageService.saveGameResult(result);

    if (!mounted) return;

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
      case NumberDifficulty.easy:
        return 'Easy';

      case NumberDifficulty.medium:
        return 'Medium';

      case NumberDifficulty.hard:
        return 'Hard';
    }
  }

  String _difficultyDescription() {
    switch (_difficulty) {
      case NumberDifficulty.easy:
        return 'Count from 1 to 5';

      case NumberDifficulty.medium:
        return 'Count from 1 to 10';

      case NumberDifficulty.hard:
        return 'Count from 1 to 20';
    }
  }

  Color _difficultyColor() {
    switch (_difficulty) {
      case NumberDifficulty.easy:
        return const Color(0xFFD8F5E3);

      case NumberDifficulty.medium:
        return const Color(0xFFFFE7A8);

      case NumberDifficulty.hard:
        return const Color(0xFFFFD6D6);
    }
  }

  Color _optionColor(int option) {
    if (!_answered) {
      return Colors.white;
    }

    if (option == _currentQuestion!.correctAnswer) {
      return const Color(0xFFD8F5E3);
    }

    return Colors.white;
  }

  Color _optionBorderColor(int option) {
    if (!_answered) {
      return Colors.transparent;
    }

    if (option == _currentQuestion!.correctAnswer) {
      return const Color(0xFF38A169);
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Number Fun',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          if (_streak >= 2)
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  right: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE7A8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '🔥 $_streak',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: Text(
                '⭐ $_correct',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
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
                //  _buildDifficultySelector(),

                  const SizedBox(height: 24),

                  _buildHeader(),

                  const SizedBox(height: 25),

                  _buildQuestionCard(),

                  const SizedBox(height: 28),

                  _buildOptions(),

                  const SizedBox(height: 20),

                  if (_answered)
                    _buildFeedback(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Difficulty',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: NumberDifficulty.values.map(
                  (difficulty) {
                final selected =
                    _difficulty == difficulty;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: _buildDifficultyButton(
                      difficulty,
                      selected,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(
      NumberDifficulty difficulty,
      bool selected,
      ) {
    final String title;

    switch (difficulty) {
      case NumberDifficulty.easy:
        title = 'Easy';

      case NumberDifficulty.medium:
        title = 'Medium';

      case NumberDifficulty.hard:
        title = 'Hard';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _answered
            ? null
            : () => _startGame(difficulty),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            color: selected
                ? _difficultyColorFor(difficulty)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppTheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: selected
                  ? AppTheme.textDark
                  : AppTheme.textLight,
            ),
          ),
        ),
      ),
    );
  }

  Color _difficultyColorFor(
      NumberDifficulty difficulty,
      ) {
    switch (difficulty) {
      case NumberDifficulty.easy:
        return const Color(0xFFD8F5E3);

      case NumberDifficulty.medium:
        return const Color(0xFFFFE7A8);

      case NumberDifficulty.hard:
        return const Color(0xFFFFD6D6);
    }
  }

  Widget _buildHeader() {
    final double progress =
        _question / totalQuestions;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Question $_question of $totalQuestions',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            Text(
              _difficultyTitle(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _difficultyDescription(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textLight,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
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

  Widget _buildQuestionCard() {
    final question = _currentQuestion;

    if (question == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animation = CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutBack,
        );

        return Transform.scale(
          scale: 0.92 + (animation.value * 0.08),
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE7A8),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFC83D)
                  .withValues(alpha: 0.25),
              blurRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'How many are there?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 25),
            _buildObjects(
              question,
            ),
            const SizedBox(height: 15),
            const Text(
              'Count carefully! 👀',
              style: TextStyle(
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

  Widget _buildObjects(NumberQuestion question) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        question.correctAnswer,
            (index) {
          return Text(
            question.emoji,
            style: const TextStyle(
              fontSize: 38,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptions() {
    final question = _currentQuestion;

    if (question == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const Text(
          'Choose the correct number',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: question.options.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (context, index) {
            return _buildOptionButton(
              question.options[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildOptionButton(int option) {
    final question = _currentQuestion!;

    final bool isCorrect =
        option == question.correctAnswer;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _answered
            ? null
            : () => _selectAnswer(option),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: _optionColor(option),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _optionBorderColor(option),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.07,
                ),
                blurRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                option.toString(),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textDark,
                ),
              ),
              if (_answered && isCorrect)
                const Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF38A169),
                    size: 25,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    final question = _currentQuestion!;

    final String message = _celebrating
        ? (_streak >= 3
        ? '🔥 $_streak in a row!'
        : 'Amazing! 🎉')
        : 'Almost! Keep trying! 💪';

    final String detail = _celebrating
        ? 'You found the right number!'
        : 'The correct answer is '
        '${question.correctAnswer}';

    return AnimatedOpacity(
      opacity: _answered ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _celebrating
              ? const Color(0xFFD8F5E3)
              : const Color(0xFFFFE0E0),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}