import 'dart:math' as math;
import 'package:flutter/material.dart';
// Harita bileşeni için gerekli paket
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  // Metin giriş alanları için kontrolcüler (Controllers)
  final TextEditingController aramaKontrolcusu = TextEditingController();
  final TextEditingController daireKontrolcusu = TextEditingController();
  final TextEditingController caddeKontrolcusu = TextEditingController();
  final TextEditingController sehirKontrolcusu = TextEditingController();
  final TextEditingController eyaletKontrolcusu = TextEditingController();
  final TextEditingController postaKoduKontrolcusu = TextEditingController();
  final TextEditingController ulkeKontrolcusu = TextEditingController();

  // Giriş alanları için kenarlık stili
  final OutlineInputBorder _inputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Color(0xFFD3D3D3)),
  );
  // Google API Anahtarı
  static const String googleApiKey = "AIzaSyCxCjJKz8p4hDgYuzpSs27mCRGAmc8BFI4";

  @override
  void dispose() {
    // Controller'ları temizle
    aramaKontrolcusu.dispose();
    daireKontrolcusu.dispose();
    caddeKontrolcusu.dispose();
    sehirKontrolcusu.dispose();
    eyaletKontrolcusu.dispose();
    postaKoduKontrolcusu.dispose();
    ulkeKontrolcusu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // Gradient arka plan
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
                // Üst Çubuk
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
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
                        'Konum Ekle',
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

                // İçerik Alanı
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth = math.min(
                        constraints.maxWidth * 0.9,
                        900,
                      );
                      final double fontSize = constraints.maxWidth > 1000
                          ? 18
                          : (constraints.maxWidth < 360 ? 14 : 16);

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
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'İlan Konumu',
                                        style: TextStyle(
                                          fontSize: fontSize + 6,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Evcil hayvan sahipleri, sadece rezervasyon yaptıklarında tam adresinizi görebilecekler.",
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 25),

                                      // Google Places Otomatik Tamamlama
                                      _buildInputField(
                                        ipucu: 'Aramak için yazın',
                                        kontrolcu: aramaKontrolcusu,
                                        saltOkunur:
                                            true, // Kullanıcının tıklayarak açması için
                                        onTap: () async {
                                          final secilenYer =
                                              await PlacesAutocomplete.show(
                                                context: context,
                                                apiKey: googleApiKey,
                                                mode: Mode.overlay,
                                                types: const [],
                                                strictbounds: false,
                                                onError: (err) => print(err),
                                              );

                                          if (secilenYer != null) {
                                            setState(() {
                                              aramaKontrolcusu.text =
                                                  secilenYer.description ?? '';
                                            });
                                          }
                                        },
                                      ),

                                      const SizedBox(height: 20),
                                      _buildInputField(
                                        ipucu: 'Daire, kat, vs.',
                                        kontrolcu: daireKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Sokak',
                                        kontrolcu: caddeKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Şehir',
                                        kontrolcu: sehirKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Eyalet / İlçe',
                                        kontrolcu: eyaletKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Posta Kodu',
                                        kontrolcu: postaKoduKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Ülke',
                                        kontrolcu: ulkeKontrolcusu,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),

                              // İLERİ Butonu
                              GestureDetector(
                                onTap: () {
                                  // Kontrol et: Tüm alanlar boş mu?
                                  if (aramaKontrolcusu.text.isEmpty ||
                                      daireKontrolcusu.text.isEmpty ||
                                      caddeKontrolcusu.text.isEmpty ||
                                      sehirKontrolcusu.text.isEmpty ||
                                      eyaletKontrolcusu.text.isEmpty ||
                                      postaKoduKontrolcusu.text.isEmpty ||
                                      ulkeKontrolcusu.text.isEmpty) {
                                    // Hata Mesajı Göster
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                        content: const Text(
                                          'Devam etmek için lütfen hizmetinizin daha doğru bir adresini girin.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: TextButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF9370DB,
                                              ),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Tamam'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    // Tüm alanlar doluysa sonraki sayfaya veya işleme geç
                                    // Örnek: Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.purple,
                                        Colors.deepPurpleAccent,
                                      ],
                                    ),
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
                                      'İLERİ',
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

  // Giriş Alanı Yapıcı Fonksiyon
  Widget _buildInputField({
    required String ipucu, // hint -> ipucu
    TextEditingController? kontrolcu, // controller -> kontrolcu
    bool saltOkunur = false, // readOnly -> saltOkunur
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: kontrolcu,
      readOnly: saltOkunur,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: ipucu,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        fillColor: Colors.white,
        filled: true,
        border: _inputBorder,
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFF8A2BE2), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
      ),
    );
  }
}
