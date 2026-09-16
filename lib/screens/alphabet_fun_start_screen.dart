import 'package:flutter/material.dart';

import '../models/alphabet_question.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';
import 'alphabet_fun_screen.dart';

class AlphabetFunStartScreen extends StatefulWidget {
  final Student student;

  const AlphabetFunStartScreen({
    super.key,
    required this.student,
  });

  @override
  State<AlphabetFunStartScreen> createState() =>
      _AlphabetFunStartScreenState();
}

class _AlphabetFunStartScreenState
    extends State<AlphabetFunStartScreen> {
  AlphabetDifficulty _selectedDifficulty =
      AlphabetDifficulty.easy;

  String _getTitle(AlphabetDifficulty difficulty) {
    switch (difficulty) {
      case AlphabetDifficulty.easy:
        return 'Easy';

      case AlphabetDifficulty.medium:
        return 'Medium';

      case AlphabetDifficulty.hard:
        return 'Hard';
    }
  }

  String _getDescription(AlphabetDifficulty difficulty) {
    switch (difficulty) {
      case AlphabetDifficulty.easy:
        return 'Learn letters from A to F';

      case AlphabetDifficulty.medium:
        return 'Practice letters from A to M';

      case AlphabetDifficulty.hard:
        return 'Master the alphabet from A to Z';
    }
  }

  String _getEmoji(AlphabetDifficulty difficulty) {
    switch (difficulty) {
      case AlphabetDifficulty.easy:
        return '🌱';

      case AlphabetDifficulty.medium:
        return '🚀';

      case AlphabetDifficulty.hard:
        return '🏆';
    }
  }

  Color _getColor(AlphabetDifficulty difficulty) {
    switch (difficulty) {
      case AlphabetDifficulty.easy:
        return const Color(0xFFD8F5E3);

      case AlphabetDifficulty.medium:
        return const Color(0xFFFFE7A8);

      case AlphabetDifficulty.hard:
        return const Color(0xFFFFD6D6);
    }
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlphabetFunScreen(
          student: widget.student,
          difficulty: _selectedDifficulty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Alphabet Fun',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            22,
            15,
            22,
            30,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 560,
              ),
              child: Column(
                children: [
                  _buildHeader(),

                  const SizedBox(height: 30),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose your level',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildDifficultyCard(
                    AlphabetDifficulty.easy,
                  ),

                  const SizedBox(height: 12),

                  _buildDifficultyCard(
                    AlphabetDifficulty.medium,
                  ),

                  const SizedBox(height: 12),

                  _buildDifficultyCard(
                    AlphabetDifficulty.hard,
                  ),

                  const SizedBox(height: 28),

                  _buildStartButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
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
      child: const Column(
        children: [
          Text(
            '🔤',
            style: TextStyle(
              fontSize: 70,
            ),
          ),

          SizedBox(height: 10),

          Text(
            'Alphabet Fun!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppTheme.textDark,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Let\'s learn our ABCs!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyCard(
      AlphabetDifficulty difficulty,
      ) {
    final bool selected =
        _selectedDifficulty == difficulty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDifficulty = difficulty;
          });
        },
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected
                ? _getColor(difficulty)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? AppTheme.primary
                  : Colors.transparent,
              width: 2.5,
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
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.8,
                  ),
                  borderRadius:
                  BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    _getEmoji(difficulty),
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(difficulty),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _getDescription(difficulty),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppTheme.primary
                      : Colors.grey.shade200,
                ),
                child: selected
                    ? const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 20,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton(
        onPressed: _startGame,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              'Start Game',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),

            SizedBox(width: 10),

            Text(
              '🚀',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}