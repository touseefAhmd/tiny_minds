import 'package:flutter/material.dart';

import '../models/memory_card.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';
import 'memory_match_screen.dart';

class MemoryMatchStartScreen extends StatefulWidget {
  final Student student;

  const MemoryMatchStartScreen({
    super.key,
    required this.student,
  });

  @override
  State<MemoryMatchStartScreen> createState() =>
      _MemoryMatchStartScreenState();
}

class _MemoryMatchStartScreenState
    extends State<MemoryMatchStartScreen> {
  int _selectedPairs = 4;

  String _getTitle(int pairs) {
    switch (pairs) {
      case 4:
        return 'Easy';

      case 6:
        return 'Medium';

      case 8:
        return 'Hard';

      default:
        return '';
    }
  }

  String _getDescription(int pairs) {
    switch (pairs) {
      case 4:
        return '4 pairs • 8 cards';

      case 6:
        return '6 pairs • 12 cards';

      case 8:
        return '8 pairs • 16 cards';

      default:
        return '';
    }
  }

  String _getEmoji(int pairs) {
    switch (pairs) {
      case 4:
        return '🌱';

      case 6:
        return '🚀';

      case 8:
        return '🏆';

      default:
        return '🧠';
    }
  }

  Color _getColor(int pairs) {
    switch (pairs) {
      case 4:
        return const Color(0xFFD8F5E3);

      case 6:
        return const Color(0xFFFFE7A8);

      case 8:
        return const Color(0xFFFFD6D6);

      default:
        return Colors.white;
    }
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemoryMatchScreen(
          student: widget.student,
          pairs: _selectedPairs,
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
          'Memory Match',
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

                  _buildDifficultyCard(4),

                  const SizedBox(height: 12),

                  _buildDifficultyCard(6),

                  const SizedBox(height: 12),

                  _buildDifficultyCard(8),

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
        color: const Color(0xFFD9D2FF),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9A8CFF)
                .withValues(alpha: 0.25),
            blurRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            '🧠',
            style: TextStyle(
              fontSize: 70,
            ),
          ),

          SizedBox(height: 10),

          Text(
            'Memory Match!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppTheme.textDark,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Find the matching pairs!',
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

  Widget _buildDifficultyCard(int pairs) {
    final bool selected = _selectedPairs == pairs;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPairs = pairs;
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
                ? _getColor(pairs)
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
                    _getEmoji(pairs),
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
                      _getTitle(pairs),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _getDescription(pairs),
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
              '🧠',
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