import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'pet_pickup_page.dart'; // PetPickUpPage importu

class BoardNotePage extends StatefulWidget {
  const BoardNotePage({super.key});

  @override
  State<BoardNotePage> createState() => _BoardNotePageState();
}

class _BoardNotePageState extends State<BoardNotePage> {
  final TextEditingController _noteController = TextEditingController();

  // Mor gradient
  final LinearGradient purpleGradient = const LinearGradient(
    colors: [Colors.purple, Colors.deepPurpleAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            child: SingleChildScrollView(
              // ← EKLEDİM
              padding: EdgeInsets.only(
                // ← EKLEDİM
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + 20, // ← EKLEDİM
              ),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30), // Başlığı biraz aşağı itti
                            child: const Text(
                              "Ek olarak bakıcının bilmesi gerekenler (isteğe bağlı)",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // İçerik kutusu
                  LayoutBuilder(
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
                                "Evcil hayvanınızla ilgili başka ihtiyaç veya özellikleri belirtin. "
                                "Örneğin agresifse ya da hassas cilt sorunları varsa.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
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
                                    hintText: "",
                                    contentPadding: EdgeInsets.all(16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),

                              // İleri butonu
                              GestureDetector(
                                onTap: () {
                                  final args = ModalRoute.of(context)
                                      ?.settings
                                      .arguments as Map;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PetPickupPage(),
                                      settings: RouteSettings(
                                        arguments: {
                                          ...args,
                                          'note': _noteController
                                              .text, // not ekleniyor
                                        },
                                      ),
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
                                      "İleri",
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
