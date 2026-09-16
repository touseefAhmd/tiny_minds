class GameResult {
  final String id;
  final String studentId;
  final String studentName;
  final String gameId;
  final String gameName;

  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;

  final int durationSeconds;
  final DateTime playedAt;

  const GameResult({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.gameId,
    required this.gameName,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.durationSeconds,
    required this.playedAt,
  });

  double get accuracy {
    if (totalQuestions == 0) return 0;

    return (correctAnswers / totalQuestions) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'gameId': gameId,
      'gameName': gameName,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'durationSeconds': durationSeconds,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  factory GameResult.fromMap(Map<dynamic, dynamic> map) {
    return GameResult(
      id: map['id']?.toString() ?? '',
      studentId: map['studentId']?.toString() ?? '',
      studentName: map['studentName']?.toString() ?? '',
      gameId: map['gameId']?.toString() ?? '',
      gameName: map['gameName']?.toString() ?? '',
      score: _toInt(map['score']),
      totalQuestions: _toInt(map['totalQuestions']),
      correctAnswers: _toInt(map['correctAnswers']),
      wrongAnswers: _toInt(map['wrongAnswers']),
      durationSeconds: _toInt(map['durationSeconds']),
      playedAt: DateTime.tryParse(
        map['playedAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}