import 'dart:math';

enum AlphabetDifficulty {
  easy,
  medium,
  hard,
}

class AlphabetQuestion {
  final String letter;
  final String word;
  final String emoji;
  final List<String> options;

  const AlphabetQuestion({
    required this.letter,
    required this.word,
    required this.emoji,
    required this.options,
  });

  static const List<Map<String, String>> _items = [
    {
      'letter': 'A',
      'word': 'Apple',
      'emoji': '🍎',
    },
    {
      'letter': 'B',
      'word': 'Ball',
      'emoji': '⚽',
    },
    {
      'letter': 'C',
      'word': 'Cat',
      'emoji': '🐱',
    },
    {
      'letter': 'D',
      'word': 'Dog',
      'emoji': '🐶',
    },
    {
      'letter': 'E',
      'word': 'Elephant',
      'emoji': '🐘',
    },
    {
      'letter': 'F',
      'word': 'Fish',
      'emoji': '🐟',
    },
    {
      'letter': 'G',
      'word': 'Grapes',
      'emoji': '🍇',
    },
    {
      'letter': 'H',
      'word': 'Horse',
      'emoji': '🐴',
    },
    {
      'letter': 'I',
      'word': 'Ice Cream',
      'emoji': '🍦',
    },
    {
      'letter': 'J',
      'word': 'Juice',
      'emoji': '🧃',
    },
    {
      'letter': 'K',
      'word': 'Kite',
      'emoji': '🪁',
    },
    {
      'letter': 'L',
      'word': 'Lion',
      'emoji': '🦁',
    },
    {
      'letter': 'M',
      'word': 'Monkey',
      'emoji': '🐒',
    },
    {
      'letter': 'N',
      'word': 'Nest',
      'emoji': '🪺',
    },
    {
      'letter': 'O',
      'word': 'Orange',
      'emoji': '🍊',
    },
    {
      'letter': 'P',
      'word': 'Penguin',
      'emoji': '🐧',
    },
    {
      'letter': 'Q',
      'word': 'Queen',
      'emoji': '👑',
    },
    {
      'letter': 'R',
      'word': 'Rabbit',
      'emoji': '🐰',
    },
    {
      'letter': 'S',
      'word': 'Sun',
      'emoji': '☀️',
    },
    {
      'letter': 'T',
      'word': 'Tiger',
      'emoji': '🐯',
    },
    {
      'letter': 'U',
      'word': 'Umbrella',
      'emoji': '☂️',
    },
    {
      'letter': 'V',
      'word': 'Van',
      'emoji': '🚐',
    },
    {
      'letter': 'W',
      'word': 'Whale',
      'emoji': '🐳',
    },
    {
      'letter': 'X',
      'word': 'Xylophone',
      'emoji': '🎵',
    },
    {
      'letter': 'Y',
      'word': 'Yo-yo',
      'emoji': '🪀',
    },
    {
      'letter': 'Z',
      'word': 'Zebra',
      'emoji': '🦓',
    },
  ];

  static AlphabetQuestion generate({
    required AlphabetDifficulty difficulty,
    Random? random,
  }) {
    final rng = random ?? Random();

    final int maxIndex;

    switch (difficulty) {
      case AlphabetDifficulty.easy:
        maxIndex = 6; // A-F
        break;

      case AlphabetDifficulty.medium:
        maxIndex = 13; // A-M
        break;

      case AlphabetDifficulty.hard:
        maxIndex = 26; // A-Z
        break;
    }

    final selectedIndex = rng.nextInt(maxIndex);
    final selected = _items[selectedIndex];

    final correctLetter = selected['letter']!;

    final Set<String> answers = {
      correctLetter,
    };

    while (answers.length < 4) {
      final randomIndex = rng.nextInt(maxIndex);
      answers.add(_items[randomIndex]['letter']!);
    }

    final options = answers.toList()..shuffle(rng);

    return AlphabetQuestion(
      letter: correctLetter,
      word: selected['word']!,
      emoji: selected['emoji']!,
      options: options,
    );
  }
}