import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/request_item.dart';
import 'package:zoozy/screens/reguests_screen.dart';
import 'package:zoozy/services/guest_access_service.dart';

class PetPickupPage extends StatefulWidget {
  const PetPickupPage({super.key});

  @override
  State<PetPickupPage> createState() => _PetPickupPageState();
}

class _PetPickupPageState extends State<PetPickupPage> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    // args içinden tarih ve saatleri çek (mümkünse null kontrolü)
  }

  void _onNext() async {
    if (!await GuestAccessService.ensureLoggedIn(context)) {
      return;
    }
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir seçenek belirleyin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;

      // Profil resmini SharedPreferences'tan al
      final prefs = await SharedPreferences.getInstance();
      String profileImageBase64 = '';

      final profileImagePath = prefs.getString('profileImagePath');
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        profileImageBase64 = profileImagePath;
      }

      final newReq = RequestItem(
        petName: args?['petName']?.toString() ?? '',
        serviceName: args?['serviceName']?.toString() ?? '',
        userPhoto: profileImageBase64, // Profil resmini kullan
        startDate: args?['startDate'] as DateTime? ?? DateTime.now(),
        endDate: args?['endDate'] as DateTime? ?? DateTime.now(),
        dayDiff: ((args?['endDate'] as DateTime? ?? DateTime.now())
                .difference(args?['startDate'] as DateTime? ?? DateTime.now())
                .inDays) +
            1,
        note: args?['note']?.toString() ?? '',
        location: args?['location']?.toString() ?? '',
      );

      final rawList = prefs.getString('requests');
      List<RequestItem> reqList =
          rawList != null ? RequestItem.decode(rawList) : [];
      reqList.add(newReq);
      await prefs.setString('requests', RequestItem.encode(reqList));

      if (!mounted) return;

      // Navigator push
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RequestsScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Üst başlık
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            "Evcil Hayvan Alma Hizmeti",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Beyaz kart
                  LayoutBuilder(
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

                              const SizedBox(height: 20),

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

                  const SizedBox(height: 20),
                ],
              ),
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
