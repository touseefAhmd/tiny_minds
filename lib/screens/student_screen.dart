import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final TextEditingController _nameController =
  TextEditingController();

  bool _loading = false;

  Future<void> _continue() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name 😊'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full name 😊'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    await StorageService.createStudent(name);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 520,
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E1FF),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text(
                        '👋',
                        style: TextStyle(fontSize: 65),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Hello, Superstar!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'What should we call you?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textLight,
                    ),
                  ),

                  const SizedBox(height: 35),

                  TextField(
                    controller: _nameController,
                    textCapitalization:
                    TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _continue(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: const Icon(
                        Icons.person_rounded,
                        size: 28,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(22),
                        borderSide: const BorderSide(
                          color: AppTheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed:
                      _loading ? null : _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(22),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            "Let's Play!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '🚀',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}