import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_result.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class GameColor {
  final String name;
  final Color color;
  final String emoji;

  const GameColor(
      this.name,
      this.color,
      this.emoji,
      );
}

const colors = [
  GameColor(
    'Red',
    Color(0xFFFF6B6B),
    '🍎',
  ),
  GameColor(
    'Blue',
    Color(0xFF5AA9FF),
    '🫐',
  ),
  GameColor(
    'Yellow',
    Color(0xFFFFC83D),
    '🌟',
  ),
  GameColor(
    'Green',
    Color(0xFF58C987),
    '🍀',
  ),
];

class ColorMatchScreen extends StatefulWidget {
  final Student student;

  const ColorMatchScreen({
    super.key,
    required this.student,
  });

  @override
  State<ColorMatchScreen> createState() =>
      _ColorMatchScreenState();
}

class _ColorMatchScreenState
    extends State<ColorMatchScreen> {
  final Random _random = Random();

  static const int totalQuestions = 10;

  late GameColor _target;

  int _question = 1;
  int _correct = 0;
  int _wrong = 0;

  bool _answered = false;
  bool _celebrating = false;

  late DateTime _startedAt;

  @override
  void initState() {
    super.initState();

    _startedAt = DateTime.now();

    _target = colors[
    _random.nextInt(colors.length)
    ];
  }

  Future<void> _choose(GameColor choice) async {
    if (_answered) return;

    final correct = choice.name == _target.name;

    setState(() {
      _answered = true;

      if (correct) {
        _correct++;
        _celebrating = true;
      } else {
        _wrong++;
      }
    });

    if (correct) {
      await Future.delayed(
        const Duration(milliseconds: 850),
      );
    } else {
      await Future.delayed(
        const Duration(milliseconds: 600),
      );
    }

    if (!mounted) return;

    if (_question >= totalQuestions) {
      await _finishGame();
      return;
    }

    setState(() {
      _question++;
      _target = colors[
      _random.nextInt(colors.length)
      ];
      _answered = false;
      _celebrating = false;
    });
  }

  Future<void> _finishGame() async {
    final duration =
    DateTime.now().difference(_startedAt);

    final result = GameResult(
      id: DateTime.now().microsecondsSinceEpoch
          .toString(),
      studentId: widget.student.id,
      studentName: widget.student.name,
      gameId: 'color_match',
      gameName: 'Color Match',
      score: _correct,
      totalQuestions: totalQuestions,
      correctAnswers: _correct,
      wrongAnswers: _wrong,
      durationSeconds: duration.inSeconds,
      playedAt: DateTime.now(),
    );

    await StorageService.saveGameResult(result);

    if (!mounted) return;

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          result: result,
        ),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Leave game?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Your current game will not be saved.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Keep Playing'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        _question / totalQuestions;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (await _confirmExit() && mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              15,
              20,
              20,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (await _confirmExit() &&
                            mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi ${widget.student.name} 👋',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 7),
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(10),
                            child:
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor:
                              Colors.white,
                              color:
                              AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE7A1),
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                      child: Text(
                        '⭐ $_correct',
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Text(
                  'Question $_question of $totalQuestions',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textLight,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Find the matching colour!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      transitionBuilder:
                          (child, animation) {
                        return ScaleTransition(
                          scale: CurvedAnimation(
                            parent: animation,
                            curve:
                            Curves.easeOutBack,
                          ),
                          child: child,
                        );
                      },
                      child: Container(
                        key: ValueKey(
                          _target.name,
                        ),
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          color: _target.color,
                          borderRadius:
                          BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: _target.color
                                  .withValues(
                                alpha: .35,
                              ),
                              blurRadius: 0,
                              offset:
                              const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _target.emoji,
                            style:
                            const TextStyle(
                              fontSize: 75,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  child: Text(
                    _celebrating
                        ? 'Amazing! 🎉'
                        : _answered
                        ? 'Nice try! 💪'
                        : 'You can do it! 🌟',
                    key: ValueKey(
                      '$_celebrating$_answered',
                    ),
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight:
                      FontWeight.w900,
                      color: _celebrating
                          ? const Color(0xFF27A866)
                          : AppTheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.75,
                  children: [
                    for (final color in colors)
                      _ColorChoice(
                        color: color,
                        enabled: !_answered,
                        onPressed: () =>
                            _choose(color),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  final GameColor color;
  final bool enabled;
  final VoidCallback onPressed;

  const _ColorChoice({
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration:
      const Duration(milliseconds: 150),
      opacity: enabled ? 1 : 0.75,
      child: ElevatedButton(
        onPressed:
        enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.color,
          foregroundColor:
          AppTheme.textDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(24),
          ),
          padding:
          const EdgeInsets.all(12),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              color.emoji,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              color.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}