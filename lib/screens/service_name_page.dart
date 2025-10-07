import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/describe_services_page.dart';

class ServiceNamePage extends StatefulWidget {
  const ServiceNamePage({super.key});

  @override
  State<ServiceNamePage> createState() => _ServiceNamePageState();
}

class _ServiceNamePageState extends State<ServiceNamePage> {
  final TextEditingController _serviceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _serviceNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    super.dispose();
  }

  Future<void> _kaydetVeDevamEt() async {
    if (_serviceNameController.text.trim().isEmpty) return;

    // Artık serviceName göndermeye gerek yok
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DescribeServicesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFilled = _serviceNameController.text.isNotEmpty;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Hizmet İsmi',
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
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth = math.min(
                        constraints.maxWidth * 0.9,
                        900,
                      );
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
                                'Hizmetinize Bir İsim Verin',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Diğerlerinden öne çıkmak için şehir/ilçe adınızı, sunduğunuz hizmeti ve kabul ettiğiniz evcil hayvan türünü birleştirebilirsiniz.',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _serviceNameController,
                                decoration: InputDecoration(
                                  hintText: 'örnek: Edirne İrem Kedi Pansiyonu',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.deepPurple,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              GestureDetector(
                                onTap: isFilled ? _kaydetVeDevamEt : null,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isFilled
                                          ? [
                                              Colors.purple,
                                              Colors.deepPurpleAccent,
                                            ]
                                          : [
                                              Colors.grey.shade400,
                                              Colors.grey.shade300,
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      if (isFilled)
                                        const BoxShadow(
                                          color: Colors.purpleAccent,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'İLERİ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
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
