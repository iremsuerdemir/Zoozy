import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PetGenderPage extends StatefulWidget {
  const PetGenderPage({super.key});

  @override
  State<PetGenderPage> createState() => _PetGenderPageState();
}

class _PetGenderPageState extends State<PetGenderPage> {
  String? selectedGender;
  final List<String> genders = ["Male", "Female", "Others"];

  Widget _getGenderIcon(String gender) {
    switch (gender) {
      case "Male":
        return const Icon(FontAwesomeIcons.mars, color: Colors.white, size: 40);
      case "Female":
        return const Icon(FontAwesomeIcons.venus,
            color: Colors.white, size: 40);
      default:
        return const Icon(FontAwesomeIcons.paw, color: Colors.white, size: 40);
    }
  }

  Color _getCardColor(String gender) {
    switch (gender) {
      case "Male":
        return Colors.blue.shade400;
      case "Female":
        return Colors.pink.shade400;
      default:
        return Colors.purple.shade400;
    }
  }

  Widget _buildGenderButton(String gender, double fontSize) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = isSelected ? null : gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? _getCardColor(gender)
              : _getCardColor(gender).withOpacity(0.2), // Açık ton
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: _getCardColor(gender).withOpacity(0.6),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getGenderIcon(gender),
            const SizedBox(height: 12),
            Text(
              gender,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB39DDB), // Açık mor
                  Color(0xFFF48FB1), // Açık pembe
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar benzeri üst bar
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
                        "Evcil Hayvanlarım",
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

                // Responsive içerik alanı
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
                                "Evcil hayvanınızın cinsiyeti nedir?",
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
                                  childAspectRatio: 0.9,
                                  children: genders
                                      .map((gender) =>
                                          _buildGenderButton(gender, fontSize))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Devam Et butonu
                              GestureDetector(
                                onTap: selectedGender != null
                                    ? () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                "Seçilen cinsiyet: $selectedGender"),
                                          ),
                                        );
                                      }
                                    : null,
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: selectedGender != null
                                          ? [
                                              Colors.purple,
                                              Colors.deepPurpleAccent
                                            ]
                                          : [
                                              Colors.grey.shade400,
                                              Colors.grey.shade300
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      if (selectedGender != null)
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
                                        color: selectedGender != null
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
