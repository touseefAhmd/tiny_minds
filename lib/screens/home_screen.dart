import 'package:flutter/material.dart';
import 'package:tiny_minds/screens/teacher_dashboard_sceen.dart';

import '../models/student.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/game_card.dart';
import 'alphabet_fun_start_screen.dart';
import 'color_match_screen.dart';
import 'memory_match_start_screen.dart';
import 'number_fun_screen.dart';
import 'number_fun_start_screen.dart';
import 'student_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Student? _student;

  @override
  void initState() {
    super.initState();

    _loadStudent();
  }

  void _loadStudent() {
    setState(() {
      _student =
          StorageService.getCurrentStudent();
    });
  }

  Future<void> _selectStudent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentScreen(),
      ),
    );

    if (result == true) {
      _loadStudent();
    }
  }

  Future<void> _openColorMatch() async {
    if (_student == null) {
      await _selectStudent();
    }

    if (!mounted) return;

    final student = StorageService.getCurrentStudent();

    if (student == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColorMatchScreen(
          student: student,
        ),
      ),
    );

    _loadStudent();
  }

  Future<void> _openTeacherDashboard() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const TeacherDashboardScreen(),
      ),
    );

    _loadStudent();
  }

  void _openNumberFun() {
    if (_student == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NumberFunStartScreen(
          student: _student!,
        ),
      ),
    );
  }
  void _openAlphabetFun() {
    if (_student == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlphabetFunStartScreen(
          student: _student!,
        ),
      ),
    );
  }

  void _openMemoryMatch() {
    if (_student == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemoryMatchStartScreen(
          student: _student!,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadStudent();
          },
          child: SingleChildScrollView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              35,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 900,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 25),

                    _buildWelcomeCard(),

                    const SizedBox(height: 28),

                    const Text(
                      'Choose a game 🎮',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight:
                        FontWeight.w900,
                        color:
                        AppTheme.textDark,
                      ),
                    ),

                    const SizedBox(height: 15),

                    _buildGameGrid(),

                    const SizedBox(height: 25),

                    _buildProgressCard(),

                    const SizedBox(height: 15),

                    _buildTeacherButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.05,
                ),
                blurRadius: 12,
                offset:
                const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '🌈',
              style:
              TextStyle(fontSize: 30),
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'TinyMinds',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight:
                  FontWeight.w900,
                  color:
                  AppTheme.textDark,
                ),
              ),
              Text(
                'Learn • Play • Grow',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppTheme.textLight,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed:
          _openTeacherDashboard,
          icon: Container(
            padding:
            const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.school_rounded,
              color:
              AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF766CFF),
            Color(0xFF9B93FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary
                .withValues(alpha: 0.25),
            blurRadius: 20,
            offset:
            const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  _student == null
                      ? 'Ready to learn? 🚀'
                      : 'Hi ${_student!.name}! 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight:
                    FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _student == null
                      ? 'Enter your name and start your learning adventure.'
                      : 'Pick a game and show us what you can do!',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight:
                    FontWeight.w600,
                    color: Colors.white
                        .withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 17),
                ElevatedButton(
                  onPressed:
                  _selectStudent,
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.white,
                    foregroundColor:
                    AppTheme.primary,
                    elevation: 0,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  child: Text(
                    _student == null
                        ? 'Enter Name'
                        : 'Change Student',
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            '🧒',
            style:
            TextStyle(fontSize: 75),
          ),
        ],
      ),
    );
  }

  Widget _buildGameGrid() {
    final games = [
      _GameInfo(
        title: 'Color Match',
        subtitle: 'Learn colors',
        emoji: '🎨',
        color:
        const Color(0xFFFFC7C7),
        available: true,
        onTap: _openColorMatch,
      ),
      _GameInfo(
        title: 'Number Fun',
        subtitle: 'Learn numbers',
        emoji: '🔢',
        color: const Color(0xFFFFE4A8),
        available: true,
        onTap: _openNumberFun,
      ),
      _GameInfo(
        title: 'Alphabet Fun',
        subtitle: 'Learn letters',
        emoji: '🔤',
        color:
        const Color(0xFFCDE8FF),
        available: true,
        onTap: _openAlphabetFun,
      ),
      _GameInfo(
        title: 'Memory Match',
        subtitle: 'Train your memory',
        emoji: '🧠',
        color: const Color(0xFFD9D2FF),
        available: true,
        onTap: _openMemoryMatch,
      ),
      _GameInfo(
        title: 'Shape Match',
        subtitle: 'Discover shapes',
        emoji: '🔷',
        color:
        const Color(0xFFCFF2DF),
        available: false,
        onTap: () {},
      ),
      _GameInfo(
        title: 'Animal Match',
        subtitle: 'Meet the animals',
        emoji: '🐾',
        color:
        const Color(0xFFFFD6B3),
        available: false,
        onTap: () {},
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
        constraints.maxWidth >= 650
            ? 3
            : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: games.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio:
            columns == 3 ? 1.15 : 0.95,
          ),
          itemBuilder: (context, index) {
            final game = games[index];

            return GameCard(
              title: game.title,
              subtitle: game.subtitle,
              emoji: game.emoji,
              color: game.color,
              available: game.available,
              onTap: game.onTap,
            );
          },
        );
      },
    );
  }

  Widget _buildProgressCard() {
    final results =
    _student == null
        ? []
        : StorageService.getStudentResults(
      _student!.id,
    );

    final gamesPlayed = results.length;

    final accuracy = results.isEmpty
        ? 0
        : results.fold<double>(
      0,
          (sum, result) =>
      sum + result.accuracy,
    ) /
        results.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(27),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
              const Color(0xFFFFE9A9),
              borderRadius:
              BorderRadius.circular(19),
            ),
            child: const Center(
              child: Text(
                '🏆',
                style:
                TextStyle(fontSize: 30),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  gamesPlayed == 0
                      ? 'Start playing to build your progress!'
                      : '$gamesPlayed games • ${accuracy.round()}% average',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color:
            AppTheme.textLight,
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed:
        _openTeacherDashboard,
        icon: const Icon(
          Icons.school_rounded,
        ),
        label: const Text(
          'Teacher Dashboard',
          style: TextStyle(
            fontWeight:
            FontWeight.w800,
          ),
        ),
        style:
        OutlinedButton.styleFrom(
          foregroundColor:
          AppTheme.textDark,
          side: BorderSide(
            color: Colors.black
                .withValues(alpha: 0.08),
          ),
          backgroundColor:
          Colors.white
              .withValues(alpha: 0.7),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _GameInfo {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final bool available;
  final VoidCallback onTap;

  const _GameInfo({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.available,
    required this.onTap,
  });
}