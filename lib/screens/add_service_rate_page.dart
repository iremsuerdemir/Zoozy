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
  // NOT: Bu sayfaya artık Açıklama Başlığı (title) için yeni controller eklemedik.
  // Geri gönderilen title, yine widget'tan gelen _serviceName olacak.
  // Ancak görseldeki 'Seçilen Hizmet' hatasını gidermek için read-only field'ı ekliyoruz.
  final TextEditingController _fiyatController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();

  // Hizmet adını tutar
  String _serviceName = '';
  bool _isFilled = false;

  void _kontrolButonDurumu() {
    setState(() {
      // Fiyat ve açıklama alanlarının dolu olup olmadığını kontrol et
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
    // ModalRoute'dan gelen serviceName argümanını alın
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    setState(() {
      // Gelen serviceName'i yakalıyoruz.
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
                // Başlık Alanı
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
                      // Dinamik Başlık
                      const Text(
                        'Servis Oranı Ekle', // Resimdeki başlık
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

                // İçerik Alanı
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
                                      // YENİ/DÜZELTİLMİŞ KISIM: Dinamik hizmet adını read-only alanda gösteriyoruz.
                                      _buildReadOnlyTextField(_serviceName),
                                      const SizedBox(height: 20),

                                      // Fiyat Giriş Alanı
                                      _buildPriceInputField(
                                        'Fiyatınız (Gecelik)',
                                        _fiyatController,
                                      ),
                                      const SizedBox(height: 15),

                                      // Açıklama Metni (Metin aynen korundu)
                                      const Text(
                                        'Evcil hayvan sahipleri, teklifinizde hangi hizmetlerin dahil olduğunu bilmekten daha rahat hissedecekler. (Örn: Mama, günlük yürüyüş, ilaç takibi vb.)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 15),

                                      // Açıklama Giriş Alanı
                                      _buildDescriptionInputField(
                                        'Açıklama',
                                        _aciklamaController,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Kaydet Butonu
                              GestureDetector(
                                onTap: _isFilled
                                    ? () {
                                        // Geri dönerken kartın BAŞLIĞI olarak hizmet adını (serviceName) gönderin.
                                        Navigator.pop(context, {
                                          'title':
                                              _serviceName, // Hizmet adı geri gönderiliyor
                                          'subtitle':
                                              '₺${_fiyatController.text}/gece\n${_aciklamaController.text}',
                                        });
                                      }
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

  // YENİ EKLEME: Read-only metin alanı
  Widget _buildReadOnlyTextField(String serviceName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
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
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPriceInputField(
    String hintText,
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
          prefixText: '₺ ',
          hintText: hintText,
          isDense: true,
        ),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

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
