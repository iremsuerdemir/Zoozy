import 'dart:math' as math;
import 'package:flutter/material.dart';

class AddServiceRatePageFromPrefs extends StatefulWidget {
  const AddServiceRatePageFromPrefs({super.key});

  @override
  State<AddServiceRatePageFromPrefs> createState() =>
      _AddServiceRatePageFromPrefsState();
}

class _AddServiceRatePageFromPrefsState
    extends State<AddServiceRatePageFromPrefs> {
  final TextEditingController _fiyatController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();
  String _serviceName = '';
  bool _isFilled = false;
  bool _isEditing = false; // ₺ otomatik ekleme kontrolü

  void _kontrolButonDurumu() {
    setState(() {
      _isFilled =
          _fiyatController.text.isNotEmpty &&
          _aciklamaController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _fiyatController.addListener(_kontrolButonDurumu);
    _aciklamaController.addListener(_kontrolButonDurumu);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🔹 Named route'tan gelen argümanı burada alıyoruz
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    setState(() {
      _serviceName = args?['serviceName'] ?? 'Servis Adı Belirtilmemiş';
    });
  }

  @override
  void dispose() {
    _fiyatController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFB39DDB);
    const Color gradientEnd = Color(0xFFF48FB1);

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Arka Plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradientStart, gradientEnd],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // 🔹 Üst Bar
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
                        'Servis Oranı Ekle',
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

                // 🔹 İçerik
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth = math.min(
                        constraints.maxWidth * 0.9,
                        900,
                      );

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
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildReadOnlyTextField(_serviceName),
                                      const SizedBox(height: 20),
                                      _buildPriceInputField(
                                        'Fiyatınız',
                                        _fiyatController,
                                      ),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'Evcil hayvan sahipleri, teklifinizde nelerin dahil olduğunu bilmekten daha rahat hissedecekler.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      _buildDescriptionInputField(
                                        'Açıklama',
                                        _aciklamaController,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // 🔹 Kaydet Butonu
                              GestureDetector(
                                onTap: _isFilled
                                    ? () =>
                                          debugPrint('Servis oranı kaydedildi')
                                    : null,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isFilled
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
                                      if (_isFilled)
                                        const BoxShadow(
                                          color: Colors.purpleAccent,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Kaydet',
                                      style: TextStyle(
                                        color: _isFilled
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

  // 🔹 Okunabilir TextField (Servis Adı)
  Widget _buildReadOnlyTextField(String serviceName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        initialValue: serviceName,
        readOnly: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // 🔹 Fiyat Alanı (₺ Otomatik Eklemeli)
  // 🔹 Fiyat Alanı (₺ her zaman başta sabit)
  Widget _buildPriceInputField(
    String labelText,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          // Sadece sayı girilmesine izin verelim
          final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (value != cleaned) {
            controller.text = cleaned;
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: cleaned.length),
            );
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixText: '₺ ', // 💰 TL simgesi sabit
          hintText: labelText,
          isDense: true,
        ),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  // 🔹 Açıklama Alanı
  Widget _buildDescriptionInputField(
    String labelText,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: labelText,
          isDense: true,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
