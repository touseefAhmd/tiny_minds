import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_result.dart';
import '../models/memory_card.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class MemoryMatchScreen extends StatefulWidget {
  final Student student;
  final int pairs;

  const MemoryMatchScreen({
    super.key,
    required this.student,
    required this.pairs,
  });

  @override
  State<MemoryMatchScreen> createState() =>
      _MemoryMatchScreenState();
}

class _MemoryMatchScreenState
    extends State<MemoryMatchScreen> {
  late List<MemoryCard> _cards;

  final Random _random = Random();

  int _moves = 0;
  int _matchedPairs = 0;

  int? _firstIndex;
  int? _secondIndex;

  bool _checking = false;

  late DateTime _startedAt;

  final List<Map<String, dynamic>> _cardData = [
    {
      'pairId': 'dog',
      'emoji': '🐶',
      'type': MemoryCardType.animal,
    },
    {
      'pairId': 'cat',
      'emoji': '🐱',
      'type': MemoryCardType.animal,
    },
    {
      'pairId': 'lion',
      'emoji': '🦁',
      'type': MemoryCardType.animal,
    },
    {
      'pairId': 'monkey',
      'emoji': '🐒',
      'type': MemoryCardType.animal,
    },
    {
      'pairId': 'apple',
      'emoji': '🍎',
      'type': MemoryCardType.fruit,
    },
    {
      'pairId': 'banana',
      'emoji': '🍌',
      'type': MemoryCardType.fruit,
    },
    {
      'pairId': 'orange',
      'emoji': '🍊',
      'type': MemoryCardType.fruit,
    },
    {
      'pairId': 'grapes',
      'emoji': '🍇',
      'type': MemoryCardType.fruit,
    },
  ];

  @override
  void initState() {
    super.initState();

    _startedAt = DateTime.now();

    _createCards();
  }

  void _createCards() {
    final selectedData =
    List<Map<String, dynamic>>.from(
      _cardData.take(widget.pairs),
    );

    final List<MemoryCard> cards = [];

    for (int i = 0; i < selectedData.length; i++) {
      final data = selectedData[i];

      cards.add(
        MemoryCard(
          id: '${data['pairId']}_1',
          pairId: data['pairId'],
          emoji: data['emoji'],
          type: data['type'],
        ),
      );

      cards.add(
        MemoryCard(
          id: '${data['pairId']}_2',
          pairId: data['pairId'],
          emoji: data['emoji'],
          type: data['type'],
        ),
      );
    }

    cards.shuffle(_random);

    _cards = cards;
  }

  void _onCardTap(int index) {
    if (_checking) {
      return;
    }

    final card = _cards[index];

    if (card.isMatched || card.isFlipped) {
      return;
    }

    if (_firstIndex == null) {
      setState(() {
        card.isFlipped = true;
        _firstIndex = index;
      });

      return;
    }

    if (_secondIndex != null) {
      return;
    }

    setState(() {
      card.isFlipped = true;
      _secondIndex = index;
      _moves++;
      _checking = true;
    });

    _checkPair();
  }

  Future<void> _checkPair() async {
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) {
      return;
    }

    final firstIndex = _firstIndex;
    final secondIndex = _secondIndex;

    if (firstIndex == null ||
        secondIndex == null) {
      return;
    }

    final firstCard = _cards[firstIndex];
    final secondCard = _cards[secondIndex];

    final bool isMatch =
        firstCard.pairId == secondCard.pairId;

    if (isMatch) {
      setState(() {
        firstCard.isMatched = true;
        secondCard.isMatched = true;

        _matchedPairs++;

        _firstIndex = null;
        _secondIndex = null;
        _checking = false;
      });

      if (_matchedPairs == widget.pairs) {
        await Future.delayed(
          const Duration(milliseconds: 600),
        );

        if (mounted) {
          _finishGame();
        }
      }
    } else {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        firstCard.isFlipped = false;
        secondCard.isFlipped = false;

        _firstIndex = null;
        _secondIndex = null;
        _checking = false;
      });
    }
  }

  Future<void> _finishGame() async {
    final duration =
    DateTime.now().difference(_startedAt);

    final totalPairs = widget.pairs;

    final result = GameResult(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      studentId: widget.student.id,
      studentName: widget.student.name,
      gameId: 'memory_match',
      gameName: 'Memory Match',
      score: _calculateScore(),
      totalQuestions: totalPairs,
      correctAnswers: totalPairs,
      wrongAnswers: _calculateWrongAttempts(),
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

  int _calculateWrongAttempts() {
    final correctMoves = widget.pairs;

    final wrongAttempts =
        _moves - correctMoves;

    return max(0, wrongAttempts);
  }

  int _calculateScore() {
    final wrongAttempts =
    _calculateWrongAttempts();

    final baseScore = widget.pairs * 10;

    final penalty = wrongAttempts * 2;

    return max(
      0,
      baseScore - penalty,
    );
  }

  String _difficultyTitle() {
    switch (widget.pairs) {
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

  @override
  Widget build(BuildContext context) {
    final columns =
    widget.pairs <= 4 ? 2 : 3;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Memory Match',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 18,
            ),
            child: Center(
              child: Text(
                '🎯 $_matchedPairs/${widget.pairs}',
                style: const TextStyle(
                  fontSize: 16,
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
            18,
            15,
            18,
            30,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                children: [
                  _buildTopInfo(),

                  const SizedBox(height: 20),

                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: _cards.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return _buildCard(index);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D2FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Text(
            '🧠',
            style: TextStyle(
              fontSize: 35,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  '${_difficultyTitle()} Level',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Find all $_matchedPairs of ${widget.pairs} pairs',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              const Text(
                'Moves',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textLight,
                ),
              ),

              Text(
                '$_moves',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    final card = _cards[index];

    final bool visible =
        card.isFlipped || card.isMatched;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),
        decoration: BoxDecoration(
          color: card.isMatched
              ? const Color(0xFFD8F5E3)
              : visible
              ? Colors.white
              : const Color(0xFF9A8CFF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: card.isMatched
                ? const Color(0xFF55B87A)
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.08,
              ),
              blurRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 180,
            ),
            child: visible
                ? Text(
              card.emoji,
              key: ValueKey(
                '${card.id}_open',
              ),
              style: const TextStyle(
                fontSize: 45,
              ),
            )
                : const Text(
              '?',
              key: ValueKey('closed'),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}