import 'package:flutter/material.dart';

import '../models/shape_question.dart';
import '../models/student.dart';
import 'shape_match_screen.dart';

class ShapeMatchStartScreen extends StatefulWidget {
  final Student student;

  const ShapeMatchStartScreen({
    super.key,
    required this.student,
  });

  @override
  State<ShapeMatchStartScreen> createState() =>
      _ShapeMatchStartScreenState();
}

class _ShapeMatchStartScreenState
    extends State<ShapeMatchStartScreen> {
  ShapeDifficulty _selectedDifficulty =
      ShapeDifficulty.easy;

  String _difficultyTitle(ShapeDifficulty difficulty) {
    switch (difficulty) {
      case ShapeDifficulty.easy:
        return 'Easy';

      case ShapeDifficulty.medium:
        return 'Medium';

      case ShapeDifficulty.hard:
        return 'Hard';
    }
  }

  String _difficultyDescription(
      ShapeDifficulty difficulty,
      ) {
    switch (difficulty) {
      case ShapeDifficulty.easy:
        return '4 simple shapes';

      case ShapeDifficulty.medium:
        return '6 different shapes';

      case ShapeDifficulty.hard:
        return 'All 8 shapes';
    }
  }

  String _difficultyEmoji(
      ShapeDifficulty difficulty,
      ) {
    switch (difficulty) {
      case ShapeDifficulty.easy:
        return '🌱';

      case ShapeDifficulty.medium:
        return '🚀';

      case ShapeDifficulty.hard:
        return '🏆';
    }
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShapeMatchScreen(
          student: widget.student,
          difficulty: _selectedDifficulty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF3),
      appBar: AppBar(
        title: const Text('Shape Match'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                '🔷',
                style: TextStyle(
                  fontSize: 72,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Shape Match!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Can you recognize the shapes?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose Difficulty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ...ShapeDifficulty.values.map(
                    (difficulty) {
                  final selected =
                      _selectedDifficulty == difficulty;

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: InkWell(
                      borderRadius:
                      BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          _selectedDifficulty =
                              difficulty;
                        });
                      },
                      child: AnimatedContainer(
                        duration:
                        const Duration(milliseconds: 200),
                        padding:
                        const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE3F2FD)
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? Colors.blue
                                : Colors.grey.shade300,
                            width: selected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              _difficultyEmoji(
                                difficulty,
                              ),
                              style: const TextStyle(
                                fontSize: 34,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _difficultyTitle(
                                      difficulty,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _difficultyDescription(
                                      difficulty,
                                    ),
                                    style: TextStyle(
                                      color:
                                      Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (selected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                                size: 28,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Start Game 🚀',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}