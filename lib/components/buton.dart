import 'package:flutter/material.dart';

class Buton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double fontSize;
  final double height;
  final Future<void> Function() onPressed; // async destekli

  const Buton({
    super.key,
    this.icon,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    required this.fontSize,
    required this.onPressed,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: () async => await onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: textColor,
                size: fontSize * 1.5,
              ),
            if (icon != null) const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
