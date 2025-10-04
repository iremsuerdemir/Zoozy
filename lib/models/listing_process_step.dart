import 'package:flutter/material.dart';

class ListingProcessStep extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final Widget? imageWidget;
  final String? learnMoreLink;

  const ListingProcessStep({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    this.imageWidget,
    this.learnMoreLink,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF5F4D8C);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$stepNumber',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    if (learnMoreLink != null)
                      GestureDetector(
                        onTap: () {
                          print('$title için Daha Fazla Bilgi tıklandı');
                        },
                        child: Text(
                          learnMoreLink!,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (imageWidget != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: imageWidget,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
