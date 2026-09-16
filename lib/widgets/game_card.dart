import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final VoidCallback onTap;
  final bool available;

  const GameCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.onTap,
    this.available = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: available ? onTap : null,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.28),
                blurRadius: 0,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Opacity(
            opacity: available ? 1 : 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      // width: 58,
                      // height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),

                    const Spacer(),

                    if (!available)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'SOON',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )
                    else
                      Container(
                        // width: 36,
                        // height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                      ),
                  ],
                ),

                const Spacer(),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF293241),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF293241)
                        .withValues(alpha: 0.68),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}