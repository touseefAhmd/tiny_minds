import 'dart:math';

enum AnimalDifficulty {
  easy,
  medium,
  hard,
}

class AnimalQuestion {
  final String animal;
  final String emoji;
  final List<String> options;

  const AnimalQuestion({
    required this.animal,
    required this.emoji,
    required this.options,
  });

  static const List<Map<String, String>> _animals = [
    {
      'animal': 'Dog',
      'emoji': '🐶',
    },
    {
      'animal': 'Cat',
      'emoji': '🐱',
    },
    {
      'animal': 'Lion',
      'emoji': '🦁',
    },
    {
      'animal': 'Elephant',
      'emoji': '🐘',
    },
    {
      'animal': 'Monkey',
      'emoji': '🐒',
    },
    {
      'animal': 'Rabbit',
      'emoji': '🐰',
    },
    {
      'animal': 'Tiger',
      'emoji': '🐯',
    },
    {
      'animal': 'Bear',
      'emoji': '🐻',
    },
    {
      'animal': 'Penguin',
      'emoji': '🐧',
    },
    {
      'animal': 'Giraffe',
      'emoji': '🦒',
    },
    {
      'animal': 'Zebra',
      'emoji': '🦓',
    },
    {
      'animal': 'Horse',
      'emoji': '🐴',
    },
    {
      'animal': 'Cow',
      'emoji': '🐮',
    },
    {
      'animal': 'Frog',
      'emoji': '🐸',
    },
    {
      'animal': 'Duck',
      'emoji': '🦆',
    },
    {
      'animal': 'Panda',
      'emoji': '🐼',
    },
  ];

  static AnimalQuestion generate({
    required AnimalDifficulty difficulty,
    Random? random,
  }) {
    final rng = random ?? Random();

    final int maxIndex;

    switch (difficulty) {
      case AnimalDifficulty.easy:
        maxIndex = 6;
        break;

      case AnimalDifficulty.medium:
        maxIndex = 11;
        break;

      case AnimalDifficulty.hard:
        maxIndex = _animals.length;
        break;
    }

    final selectedIndex = rng.nextInt(maxIndex);
    final selected = _animals[selectedIndex];

    final correctAnswer = selected['animal']!;

    final Set<String> answers = {
      correctAnswer,
    };

    while (answers.length < 4) {
      final randomIndex = rng.nextInt(maxIndex);

      answers.add(
        _animals[randomIndex]['animal']!,
      );
    }

    final options = answers.toList()..shuffle(rng);

    return AnimalQuestion(
      animal: correctAnswer,
      emoji: selected['emoji']!,
      options: options,
    );
  }
}