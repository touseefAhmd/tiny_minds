import 'package:flutter/material.dart';

import '../models/animal_question.dart';
import '../models/student.dart';
import 'animal_match_screen.dart';

class AnimalMatchStartScreen extends StatefulWidget {
  final Student student;

  const AnimalMatchStartScreen({
    super.key,
    required this.student,
  });

  @override
  State<AnimalMatchStartScreen> createState() =>
      _AnimalMatchStartScreenState();
}

class _AnimalMatchStartScreenState
    extends State<AnimalMatchStartScreen> {
  AnimalDifficulty _selectedDifficulty =
      AnimalDifficulty.easy;

  String _difficultyTitle(
      AnimalDifficulty difficulty,
      ) {
    switch (difficulty) {
      case AnimalDifficulty.easy:
        return 'Easy';

      case AnimalDifficulty.medium:
        return 'Medium';

      case AnimalDifficulty.hard:
        return 'Hard';
    }
  }

  String _difficultyDescription(
      AnimalDifficulty difficulty,
      ) {
    switch (difficulty) {
      case AnimalDifficulty.easy:
        return '6 friendly animals';

      case AnimalDifficulty.medium:
        return '11 different animals';

      case AnimalDifficulty.hard:
        return '16 animals to discover';
    }
  }

  String _difficultyEmoji(
      AnimalDifficulty difficulty,
      ) {
    switch (difficulty) {
      case AnimalDifficulty.easy:
        return '🌱';

      case AnimalDifficulty.medium:
        return '🚀';

      case AnimalDifficulty.hard:
        return '🏆';
    }
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnimalMatchScreen(
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
        title: const Text('Animal Match'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                '🐾',
                style: TextStyle(
                  fontSize: 72,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Animal Match!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Can you recognize the animals?',
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

              ...AnimalDifficulty.values.map(
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
                              ? const Color(0xFFFFE8C8)
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? Colors.orange
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
                                color: Colors.orange,
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