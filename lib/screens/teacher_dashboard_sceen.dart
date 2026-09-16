import 'package:flutter/material.dart';

import '../models/game_result.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends State<TeacherDashboardScreen> {
  List<Student> _students = [];
  List<GameResult> _results = [];

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() {
    setState(() {
      _students =
          StorageService.getStudents();
      _results =
          StorageService.getResults();
    });
  }

  Future<void> _deleteStudent(
      Student student,
      ) async {
    final confirm =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete student?',
          ),
          content: Text(
            'This will delete ${student.name} and all of their game results.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                    context,
                    false,
                  ),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(
                    context,
                    true,
                  ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await StorageService.deleteStudent(
      student.id,
    );

    _loadData();
  }

  Future<void> _clearResults() async {
    if (_results.isEmpty) return;

    final confirm =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Clear all results?',
          ),
          content: const Text(
            'All game results will be permanently removed.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                    context,
                    false,
                  ),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(
                    context,
                    true,
                  ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await StorageService.clearAllResults();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Teacher Dashboard',
          style: TextStyle(
            fontWeight:
            FontWeight.w900,
          ),
        ),
        actions: [
          if (_results.isNotEmpty)
            IconButton(
              onPressed: _clearResults,
              tooltip: 'Clear results',
              icon: const Icon(
                Icons.delete_sweep_rounded,
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            _buildStats(),

            const SizedBox(height: 28),

            const Text(
              'Students',
              style: TextStyle(
                fontSize: 25,
                fontWeight:
                FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            if (_students.isEmpty)
              _buildEmptyState()
            else
              ..._students.map(
                    (student) =>
                    _StudentTile(
                      student: student,
                      results:
                      _results
                          .where(
                            (result) =>
                        result.studentId ==
                            student.id,
                      )
                          .toList(),
                      onDelete: () =>
                          _deleteStudent(
                            student,
                          ),
                    ),
              ),

            const SizedBox(height: 28),

            const Text(
              'Recent Results',
              style: TextStyle(
                fontSize: 25,
                fontWeight:
                FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            if (_results.isEmpty)
              const Text(
                'No games have been played yet.',
                style: TextStyle(
                  color:
                  AppTheme.textLight,
                  fontWeight:
                  FontWeight.w600,
                ),
              )
            else
              ..._results
                  .take(20)
                  .map(
                    (result) =>
                    _ResultTile(
                      result: result,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    final average =
        StorageService.averageAccuracy;

    return Row(
      children: [
        Expanded(
          child: _DashboardStat(
            emoji: '👨‍🎓',
            value:
            '${StorageService.totalStudents}',
            label: 'Students',
            color:
            const Color(0xFFE5E1FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DashboardStat(
            emoji: '🎮',
            value:
            '${StorageService.totalGamesPlayed}',
            label: 'Games',
            color:
            const Color(0xFFFFE7B0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DashboardStat(
            emoji: '🎯',
            value:
            '${average.round()}%',
            label: 'Average',
            color:
            const Color(0xFFD9F3E4),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding:
      const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(25),
      ),
      child: const Column(
        children: [
          Text(
            '👩‍🏫',
            style:
            TextStyle(fontSize: 55),
          ),
          SizedBox(height: 12),
          Text(
            'No students yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w900,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Students will appear here after they start playing.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
              AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardStat
    extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _DashboardStat({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 17,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius:
        BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style:
            const TextStyle(
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style:
            const TextStyle(
              fontSize: 21,
              fontWeight:
              FontWeight.w900,
            ),
          ),
          Text(
            label,
            style:
            const TextStyle(
              fontSize: 11,
              fontWeight:
              FontWeight.w700,
              color:
              AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentTile
    extends StatelessWidget {
  final Student student;
  final List<GameResult> results;
  final VoidCallback onDelete;

  const _StudentTile({
    required this.student,
    required this.results,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final average = results.isEmpty
        ? 0
        : results.fold<double>(
      0,
          (sum, result) =>
      sum + result.accuracy,
    ) /
        results.length;

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
              const Color(0xFFE7E2FF),
              borderRadius:
              BorderRadius.circular(17),
            ),
            child: const Center(
              child: Text(
                '👦',
                style:
                TextStyle(
                  fontSize: 27,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style:
                  const TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${results.length} games played',
                  style:
                  const TextStyle(
                    fontSize: 12,
                    color:
                    AppTheme.textLight,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Text(
                '${average.round()}%',
                style:
                const TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w900,
                  color:
                  AppTheme.primary,
                ),
              ),
              const Text(
                'average',
                style:
                TextStyle(
                  fontSize: 10,
                  color:
                  AppTheme.textLight,
                ),
              ),
            ],
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete student',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultTile
    extends StatelessWidget {
  final GameResult result;

  const _ResultTile({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
              const Color(0xFFFFE9A9),
              borderRadius:
              BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                '🎨',
                style:
                TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  result.studentName,
                  style:
                  const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  result.gameName,
                  style:
                  const TextStyle(
                    fontSize: 12,
                    color:
                    AppTheme.textLight,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Text(
                '${result.score}/${result.totalQuestions}',
                style:
                const TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),
              Text(
                '${result.accuracy.round()}%',
                style:
                const TextStyle(
                  fontSize: 11,
                  color:
                  AppTheme.primary,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}