import 'dart:math' as math;

import 'package:flutter/material.dart';

class SessionCountPage extends StatefulWidget {
  const SessionCountPage({super.key});

  @override
  State<SessionCountPage> createState() => _SessionCountPageState();
}

class _SessionCountPageState extends State<SessionCountPage> {
  final TextEditingController _sessionController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _sessionController.addListener(() {
      setState(() {
        _isButtonEnabled = _sessionController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _sessionController.dispose();
    super.dispose();
  }

  void _onNext() {
    final input = _sessionController.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          input.isEmpty
              ? 'Lütfen bir sayı girin.'
              : 'Girilen seans sayısı: $input',
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
                                "Kaç seansa ihtiyacınız var?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),

                              Focus(
                                onFocusChange: (hasFocus) {
                                  setState(() {
                                    _isFocused = hasFocus;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _isFocused
                                            ? Colors.deepPurple.withOpacity(0.3)
                                            : Colors.grey.withOpacity(0.1),
                                        blurRadius: _isFocused ? 12 : 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: _isFocused
                                          ? Colors.deepPurple
                                          : Colors.grey.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _sessionController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 18),
                                      hintText: '1, 2, 3, ...',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(fontSize: fontSize),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Devam Et butonu
                              GestureDetector(
                                onTap: _isButtonEnabled ? _onNext : null,
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isButtonEnabled
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
                                      if (_isButtonEnabled)
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
                                        color: _isButtonEnabled
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
