import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../screens/pet_pickup_page.dart';

class GroomerNotePage extends StatefulWidget {
  const GroomerNotePage({super.key});

  @override
  State<GroomerNotePage> createState() => _GroomerNotePageState();
}

class _GroomerNotePageState extends State<GroomerNotePage> {
  final TextEditingController _noteController = TextEditingController();

  // Mor gradient (PetVetPage’dekiyle aynı)
  final LinearGradient purpleGradient = const LinearGradient(
    colors: [Colors.purple, Colors.deepPurpleAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan (açık mor-pembe degrade)
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
                // Üst bar
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
                        "Tıraş Notu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // İçerik kutusu
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth =
                          math.min(constraints.maxWidth * 0.9, 600);

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
                                "Tıraşçıya iletmek istediğiniz başka bir şey var mı?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Evcil hayvanınızla ilgili başka ihtiyaç veya özellikleri belirtin. "
                                "Örneğin agresifse ya da hassas cildi varsa bunları yazabilirsiniz.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Not alanı
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1.4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _noteController,
                                  maxLines: 6,
                                  decoration: const InputDecoration(
                                    hintText:
                                        "Notunuzu buraya yazın... (isteğe bağlı)",
                                    contentPadding: EdgeInsets.all(16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Gönder butonu (mor gradient)
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  // Notu, önceki tüm bilgileri ve notu ilet
                                  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                                  String petName = args != null ? (args['petName'] ?? '') : '';
                                  String serviceName = args != null ? (args['serviceName'] ?? '') : '';
                                  DateTime startDate = args != null ? (args['startDate'] ?? DateTime.now()) : DateTime.now();
                                  DateTime endDate = args != null ? (args['endDate'] ?? DateTime.now()) : DateTime.now();
                                  // eğer foto yolu varsa onu da ekle (ör: userPhoto)
                                  String note = _noteController.text;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PetPickupPage(),
                                      settings: RouteSettings(arguments: {
                                        'petName': petName,
                                        'serviceName': serviceName,
                                        'startDate': startDate,
                                        'endDate': endDate,
                                        'note': note,
                                        // userPhoto da eklenebilir
                                      }),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: purpleGradient,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Gönder",
                                      style: TextStyle(
                                        color: Colors.white,
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
