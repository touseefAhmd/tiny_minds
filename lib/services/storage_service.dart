import 'package:hive/hive.dart';

import '../models/game_result.dart';
import '../models/student.dart';

class StorageService {
  static const String _studentsBoxName = 'students_box';
  static const String _resultsBoxName = 'results_box';
  static const String _settingsBoxName = 'settings_box';

  static late Box _studentsBox;
  static late Box _resultsBox;
  static late Box _settingsBox;

  static Future<void> initialize() async {
    _studentsBox = await Hive.openBox(_studentsBoxName);
    _resultsBox = await Hive.openBox(_resultsBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // ------------------------------------------------------------
  // CURRENT STUDENT
  // ------------------------------------------------------------

  static String? get currentStudentId {
    return _settingsBox.get('currentStudentId')?.toString();
  }

  static Future<void> setCurrentStudent(String studentId) async {
    await _settingsBox.put('currentStudentId', studentId);
  }

  static Future<void> clearCurrentStudent() async {
    await _settingsBox.delete('currentStudentId');
  }

  static Student? getCurrentStudent() {
    final id = currentStudentId;

    if (id == null) return null;

    final data = _studentsBox.get(id);

    if (data == null) return null;

    return Student.fromMap(data);
  }

  // ------------------------------------------------------------
  // STUDENTS
  // ------------------------------------------------------------

  static List<Student> getStudents() {
    final students = _studentsBox.values
        .map(
          (data) => Student.fromMap(data),
    )
        .toList();

    students.sort(
          (a, b) => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
    );

    return students;
  }

  static Future<Student> createStudent(String name) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    final student = Student(
      id: id,
      name: name.trim(),
      createdAt: DateTime.now(),
    );

    await _studentsBox.put(
      id,
      student.toMap(),
    );

    await setCurrentStudent(id);

    return student;
  }

  static Future<void> deleteStudent(String studentId) async {
    await _studentsBox.delete(studentId);

    final resultKeys = <dynamic>[];

    for (final key in _resultsBox.keys) {
      final data = _resultsBox.get(key);

      if (data is Map &&
          data['studentId']?.toString() == studentId) {
        resultKeys.add(key);
      }
    }

    await _resultsBox.deleteAll(resultKeys);

    if (currentStudentId == studentId) {
      await clearCurrentStudent();
    }
  }

  // ------------------------------------------------------------
  // GAME RESULTS
  // ------------------------------------------------------------

  static List<GameResult> getResults() {
    final results = _resultsBox.values
        .map(
          (data) => GameResult.fromMap(data),
    )
        .toList();

    results.sort(
          (a, b) => b.playedAt.compareTo(a.playedAt),
    );

    return results;
  }

  static List<GameResult> getStudentResults(
      String studentId,
      ) {
    return getResults()
        .where(
          (result) => result.studentId == studentId,
    )
        .toList();
  }

  static Future<void> saveGameResult(
      GameResult result,
      ) async {
    await _resultsBox.put(
      result.id,
      result.toMap(),
    );
  }

  static Future<void> deleteResult(String resultId) async {
    await _resultsBox.delete(resultId);
  }

  static Future<void> clearAllResults() async {
    await _resultsBox.clear();
  }

  // ------------------------------------------------------------
  // STATISTICS
  // ------------------------------------------------------------

  static int get totalGamesPlayed {
    return _resultsBox.length;
  }

  static int get totalStudents {
    return _studentsBox.length;
  }

  static int get totalStars {
    int total = 0;

    for (final result in getResults()) {
      if (result is GameResult) {
        total += result.score;
      }
    }

    return total;
  }

  static double get averageAccuracy {
    final results = getResults();

    if (results.isEmpty) return 0;

    final total = results.fold<double>(
      0,
          (sum, result) => sum + result.accuracy,
    );

    return total / results.length;
  }
}