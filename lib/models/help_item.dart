import 'package:flutter/material.dart';

class HelpItem {
  final IconData icon;
  final String title;
  final String description;
  final Future<void> Function() action;
  HelpItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
  });
}
