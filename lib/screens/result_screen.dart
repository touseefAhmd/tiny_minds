import 'package:flutter/material.dart';

import '../models/game_result.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final GameResult result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  String get _message {
    final accuracy = result.accuracy;

    if (accuracy >= 90) {
      return 'Amazing work! 🌟';
    }

    if (accuracy >= 70) {
      return 'Great job! 🎉';
    }

    if (accuracy >= 50) {
      return 'Good effort! 💪';
    }

    return 'Keep practicing! 🚀';
  }

  String get _emoji {
    final accuracy = result.accuracy;

    if (accuracy >= 90) return '🏆';
    if (accuracy >= 70) return '🌟';
    if (accuracy >= 50) return '😊';

    return '💪';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: Column(
                  children: [
                    Text(
                      _emoji,
                      style: const TextStyle(
                        fontSize: 78,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      _message,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight:
                        FontWeight.w900,
                        color:
                        AppTheme.textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Well done, ${result.studentName}!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppTheme.textLight,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding:
                      const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 25,
                            offset:
                            const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'YOUR SCORE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                              FontWeight.w900,
                              color:
                              AppTheme.textLight,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${result.score}/${result.totalQuestions}',
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight:
                              FontWeight.w900,
                              color:
                              AppTheme.primary,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child:
                                _StatCard(
                                  emoji: '✅',
                                  value: '${result.correctAnswers}',
                                  label: 'Correct',
                                  color:
                                  const Color(
                                    0xFFDFF7E9,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child:
                                _StatCard(
                                  emoji: '❌',
                                  value: '${result.wrongAnswers}',
                                  label: 'Wrong',
                                  color:
                                  const Color(
                                    0xFFFFE0E0,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child:
                                _StatCard(
                                  emoji: '🎯',
                                  value:
                                  '${result.accuracy.round()}%',
                                  label: 'Accuracy',
                                  color:
                                  const Color(
                                    0xFFE7E2FF,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child:
                                _StatCard(
                                  emoji: '⏱️',
                                  value:
                                  '${result.durationSeconds}s',
                                  label: 'Time',
                                  color:
                                  const Color(
                                    0xFFFFF0C7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const HomeScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          AppTheme.primary,
                          foregroundColor:
                          Colors.white,
                          elevation: 0,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              21,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Back to Games 🚀',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style:
            const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}