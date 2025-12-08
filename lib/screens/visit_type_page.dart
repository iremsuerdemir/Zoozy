import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/my_cities_page.dart';

class VisitTypePage extends StatefulWidget {
  final String petName;
  final String serviceName;

  const VisitTypePage({
    super.key,
    required this.petName,
    required this.serviceName,
  });

  @override
  State<VisitTypePage> createState() => _VisitTypePageState();
}

class _VisitTypePageState extends State<VisitTypePage> {
  // Ziyaret tipleri
  final List<String> visitTypes = [
    "Gece konaklama",
    "Günde 1 ziyaret",
    "Günde 2 ziyaret",
    "Günde 3 ziyaret",
  ];

  String? selectedType;

  // ServiceDatePage'den gelecek veriler
  Map<String, dynamic>? incomingArgs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    incomingArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    print("VisitTypePage gelen ARGUMENTS: $incomingArgs");
  }

  // Ana gradient
  final LinearGradient appGradient = const LinearGradient(
    colors: [
      Colors.purple,
      Colors.deepPurpleAccent,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Ziyaret butonu widget
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
                colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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

                // İçerik
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
                                offset: const Offset(0, 4),
                                spreadRadius: 2,
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
                                  childAspectRatio: 2.5,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  children: visitTypes
                                      .map((t) =>
                                          _buildVisitButton(t, fontSize))
                                      .toList(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // === İLERİ BUTONU: ARGUMENTS GÖNDERİLDİ ===
                              GestureDetector(
                                onTap: selectedType != null
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const MyCitiesPage(),
                                            settings: RouteSettings(
                                              arguments: {
                                                "petName": widget.petName,
                                                "serviceName":
                                                    widget.serviceName,
                                                "startDate":
                                                    incomingArgs?["startDate"],
                                                "startTime":
                                                    incomingArgs?["startTime"],
                                                "endDate":
                                                    incomingArgs?["endDate"],
                                                "endTime":
                                                    incomingArgs?["endTime"],
                                                "visitType": selectedType,
                                              },
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
                                              Colors.grey.shade300,
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      if (selectedType != null)
                                        BoxShadow(
                                          color: Colors.purpleAccent
                                              .withOpacity(0.6),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "İleri",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: selectedType != null
                                            ? Colors.white
                                            : Colors.black54,
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
