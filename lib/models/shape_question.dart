import 'dart:math';

enum ShapeDifficulty {
  easy,
  medium,
  hard,
}

class ShapeQuestion {
  final String shape;
  final String displayName;
  final String emoji;
  final List<String> options;

  const ShapeQuestion({
    required this.shape,
    required this.displayName,
    required this.emoji,
    required this.options,
  });

  static const List<Map<String, String>> _shapes = [
    {
      'shape': 'circle',
      'name': 'Circle',
      'emoji': '⚪',
    },
    {
      'shape': 'square',
      'name': 'Square',
      'emoji': '🟦',
    },
    {
      'shape': 'triangle',
      'name': 'Triangle',
      'emoji': '🔺',
    },
    {
      'shape': 'rectangle',
      'name': 'Rectangle',
      'emoji': '▭',
    },
    {
      'shape': 'star',
      'name': 'Star',
      'emoji': '⭐',
    },
    {
      'shape': 'oval',
      'name': 'Oval',
      'emoji': '🥚',
    },
    {
      'shape': 'diamond',
      'name': 'Diamond',
      'emoji': '🔷',
    },
    {
      'shape': 'heart',
      'name': 'Heart',
      'emoji': '❤️',
    },
  ];

  static ShapeQuestion generate({
    required ShapeDifficulty difficulty,
    Random? random,
  }) {
    final rng = random ?? Random();

    final int maxIndex;

    switch (difficulty) {
      case ShapeDifficulty.easy:
        maxIndex = 4;
        break;

      case ShapeDifficulty.medium:
        maxIndex = 6;
        break;

      case ShapeDifficulty.hard:
        maxIndex = 8;
        break;
    }

    final selectedIndex = rng.nextInt(maxIndex);
    final selected = _shapes[selectedIndex];

    final correctAnswer = selected['name']!;

    final Set<String> answers = {correctAnswer};

    while (answers.length < 4) {
      final randomIndex = rng.nextInt(maxIndex);

      answers.add(
        _shapes[randomIndex]['name']!,
      );
    }

    final options = answers.toList()..shuffle(rng);

    return ShapeQuestion(
      shape: selected['shape']!,
      displayName: selected['name']!,
      emoji: selected['emoji']!,
      options: options,
    );
  }
}