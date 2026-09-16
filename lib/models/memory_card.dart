enum MemoryCardType {
  animal,
  fruit,
  object,
}

class MemoryCard {
  final String id;
  final String pairId;
  final String emoji;
  final MemoryCardType type;

  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.pairId,
    required this.emoji,
    required this.type,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id,
      pairId: pairId,
      emoji: emoji,
      type: type,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}