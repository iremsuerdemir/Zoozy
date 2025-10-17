import 'dart:math' as math;

import 'package:flutter/material.dart';

class VisitTypePage extends StatefulWidget {
  const VisitTypePage({super.key});

  @override
  State<VisitTypePage> createState() => _VisitTypePageState();
}

class _VisitTypePageState extends State<VisitTypePage> {
  final List<String> visitTypes = [
    "Gece konaklama",
    "Günde 1 ziyaret",
    "Günde 2 ziyaret",
    "Günde 3 ziyaret",
  ];

  String? selectedType;

  final LinearGradient appGradient = const LinearGradient(
    colors: [
      Colors.purple,
      Colors.deepPurpleAccent,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Widget _buildVisitButton(String type, double fontSize) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected ? appGradient : null,
          color: isSelected ? null : Colors.purpleAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.deepPurpleAccent.withOpacity(0.6),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              type,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB39DDB),
                  Color(0xFFF48FB1),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Üst başlık
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Ziyaret Türü",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Ana içerik
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth =
                          math.min(constraints.maxWidth * 0.9, 900);
                      final double fontSize = constraints.maxWidth > 1000
                          ? 18
                          : (constraints.maxWidth < 360 ? 14 : 16);

                      return Center(
                        child: Container(
                          width: maxContentWidth,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Evcil hayvanınızı günde kaç kez ziyaret etmemizi istersiniz?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 2.5,
                                  children: visitTypes
                                      .map((type) =>
                                          _buildVisitButton(type, fontSize))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // İleri Butonu
                              GestureDetector(
                                onTap: selectedType != null
                                    ? () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                              "Seçilen ziyaret türü: $selectedType",
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: selectedType != null
                                        ? appGradient
                                        : LinearGradient(
                                            colors: [
                                              Colors.grey.shade400,
                                              Colors.grey.shade300
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      if (selectedType != null)
                                        const BoxShadow(
                                          color: Colors.purpleAccent,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "İleri",
                                      style: TextStyle(
                                        color: selectedType != null
                                            ? Colors.white
                                            : Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
