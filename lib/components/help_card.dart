import 'package:flutter/material.dart';

import '../components/buton.dart';
import '../models/help_item.dart';

class HelpCard extends StatelessWidget {
  final HelpItem item;

  const HelpCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200, // Kart minimum yüksekliği
        maxHeight: 240, // Kart çok büyümesin
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Icon(item.icon, size: 42, color: const Color(0xFF7A4FAD)),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
            Buton(
              text: "Aç",
              buttonColor: const Color(0xFF7A4FAD),
              textColor: Colors.white,
              fontSize: 13,
              height: 36,
              onPressed: () async => await item.action(),
            ),
          ],
        ),
      ),
    );
  }
}
