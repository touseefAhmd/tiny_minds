import 'package:flutter/material.dart';

class GameInfo {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final bool available;

  const GameInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    this.available = true,
  });
}