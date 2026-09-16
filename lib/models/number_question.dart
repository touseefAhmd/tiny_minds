import 'dart:math';

enum NumberDifficulty {
  easy,
  medium,
  hard,
}

class NumberQuestion {
  final int correctAnswer;
  final List<int> options;
  final String emoji;

  const NumberQuestion({
    required this.correctAnswer,
    required this.options,
    required this.emoji,
  });

  static const List<String> _objects = [
    '🍎',
    '🐶',
    '🐱',
    '🚗',
    '🦋',
    '🍌',
    '🌸',
    '⚽',
    '🐟',
    '⭐',
  ];

  static NumberQuestion generate({
    required NumberDifficulty difficulty,
    Random? random,
  }) {
    final rng = random ?? Random();

    final int maxNumber;

    switch (difficulty) {
      case NumberDifficulty.easy:
        maxNumber = 5;
        break;

      case NumberDifficulty.medium:
        maxNumber = 10;
        break;

      case NumberDifficulty.hard:
        maxNumber = 20;
        break;
    }

    final correctAnswer = rng.nextInt(maxNumber) + 1;

    final Set<int> answers = {
      correctAnswer,
    };

    while (answers.length < 4) {
      answers.add(
        rng.nextInt(maxNumber) + 1,
      );
    }

    final options = answers.toList()..shuffle(rng);

    final emoji = _objects[
    rng.nextInt(_objects.length)
    ];

    return NumberQuestion(
      correctAnswer: correctAnswer,
      options: options,
      emoji: emoji,
    );
  }
}