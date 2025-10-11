import 'package:flutter/material.dart';

class EmptyCardWidget extends StatelessWidget {
  final String? photo;
  final String? title;
  final String? description;
  final String? buttonText;
  final Future<void> Function()? action;

  const EmptyCardWidget({
    super.key,
    this.photo,
    this.title,
    this.description,
    this.buttonText,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade400, 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (photo != null)
            Image.asset(photo!),
          const SizedBox(height: 12),
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
          const SizedBox(height: 8),
          if (description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                description!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70, 
                ),
              ),
            ),
          const SizedBox(height: 12),
          if (buttonText != null)
            ElevatedButton(
              onPressed: () async {
                if (action != null) await action!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                buttonText!,
                style: const TextStyle(
                  color: Colors.black, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
