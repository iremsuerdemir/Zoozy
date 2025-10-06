import 'dart:math' as math;

import 'package:flutter/material.dart';

class PetPickupPage extends StatefulWidget {
  const PetPickupPage({super.key});

  @override
  State<PetPickupPage> createState() => _PetPickupPageState();
}

class _PetPickupPageState extends State<PetPickupPage> {
  String? _selectedOption;

  void _onNext() {}

  @override
  Widget build(BuildContext context) {
    const purpleGradient = LinearGradient(
      colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final bool isButtonActive = _selectedOption != null;

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan degrade
          Container(
            decoration: const BoxDecoration(gradient: purpleGradient),
          ),

          SafeArea(
            child: Column(
              children: [
                // Üst başlık
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Evcil Hayvan Alma Hizmeti",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Beyaz kart
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth =
                          math.min(constraints.maxWidth * 0.9, 600);

                      return Center(
                        child: Container(
                          width: maxWidth,
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
                                "Evcil hayvanınızı almak için bir hizmete ihtiyaç duyuyor musunuz?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Backers, evcil hayvanınızı güvenle almak veya teslim etmek için bu hizmeti sağlar.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 24),

                              _buildOptionCard("Evet"),
                              const SizedBox(height: 12),
                              _buildOptionCard("Hayır"),

                              const Spacer(),

                              // Mor degrade ileri butonu
                              GestureDetector(
                                onTap: isButtonActive ? _onNext : null,
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: isButtonActive
                                        ? const LinearGradient(
                                            colors: [
                                              Colors.purple,
                                              Colors.deepPurpleAccent,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : LinearGradient(
                                            colors: [
                                              Colors.grey.shade400,
                                              Colors.grey.shade300,
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      if (isButtonActive)
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
                                        color: isButtonActive
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

  Widget _buildOptionCard(String option) {
    final bool isSelected = _selectedOption == option;

    return InkWell(
      onTap: () {
        setState(() => _selectedOption = option);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: _selectedOption,
              activeColor: Colors.purple,
              onChanged: (value) {
                setState(() => _selectedOption = value);
              },
            ),
            const SizedBox(width: 4),
            Text(
              option,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.purple.shade700 : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
