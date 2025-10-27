import 'package:flutter/material.dart';

class InboxActionsBar extends StatelessWidget {
  final int tabIndex;
  final VoidCallback? onPressed;

  const InboxActionsBar({super.key, required this.tabIndex, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        tabIndex == 2
            ? IconButton(
                onPressed: onPressed ?? () {},
                icon: const Icon(
                  Icons.check,
                  color: Color.fromARGB(255, 14, 90, 16),
                  size: 28,
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF673AB7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color(0xFF673AB7),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 0,
                ),
                onPressed: onPressed ?? () {},
                child: const Text(
                  'Düzenle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF673AB7),
                  ),
                ),
              ),
      ],
    );
  }
}
