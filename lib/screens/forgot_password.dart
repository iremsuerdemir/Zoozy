import 'package:flutter/material.dart';

// Renk sabitleri
const Color kAnaMor = Color(0xFF8C60A8);
const Color kAcikMor = Color(0xFFF0EAF5);
const Color kKoyuYazi = Color(0xFF4C4C4C);

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  // Tekrar kullanılabilir buton oluşturma fonksiyonu
  Widget _butonOlustur({
    required String metin,
    required Color renk,
    required Color metinRengi,
    required VoidCallback tiklamaFonksiyonu,
    bool cizgili = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: tiklamaFonksiyonu,
          style: ElevatedButton.styleFrom(
            backgroundColor: renk,
            foregroundColor: metinRengi,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: cizgili
                  ? const BorderSide(color: kAnaMor, width: 2)
                  : BorderSide.none,
            ),
            elevation: 5,
          ),
          child: Text(
            metin,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Şifre sıfırlama butonuna tıklandığında çalışacak fonksiyon
  void _sifirlamaLinkiniGonder() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(
            255,
            19,
            187,
            89,
          ),
          content: Text(
            'Şifre sıfırlama linki gönderildi!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold arka planını kaplayan gradient Container
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Tam sayfa gradient
          gradient: LinearGradient(
            colors: [Color(0xFFB2A4FF), Color(0xFFFFC1C1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          // LayoutBuilder ile ekran boyutunu alıyoruz
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // İçerik az olsa bile minimum ekran yüksekliğini koru (dikey ortalama için)
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // İçeriği dikey olarak ortalar
                      children: [
                        // Başlık (Logo)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Geri ok butonu
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white, size: 28),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.pets,
                                  color: Colors.white, size: 30),
                              const SizedBox(width: 8),
                              const Text(
                                'Zoozy',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Form kartı (Beyaz kısım)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Şifre Sıfırlama',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: kKoyuYazi,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Hesabınıza bağlı e-posta adresinizi girin, size şifrenizi sıfırlamanız için bir bağlantı göndereceğiz.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'E-posta',
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: const BorderSide(
                                            color: kAnaMor,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Lütfen e-posta adresinizi girin';
                                        }
                                        if (!RegExp(
                                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                            .hasMatch(value)) {
                                          return 'Geçersiz e-posta adresi';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 25),
                                    _butonOlustur(
                                      metin: 'SIFRILAMA LİNKİ GÖNDER',
                                      renk: kAnaMor,
                                      metinRengi: Colors.white,
                                      tiklamaFonksiyonu:
                                          _sifirlamaLinkiniGonder,
                                    ),
                                    const SizedBox(height: 15),
                                    _butonOlustur(
                                      metin: 'GERİ',
                                      renk: Colors.white,
                                      metinRengi: Colors.grey,
                                      tiklamaFonksiyonu: () =>
                                          Navigator.pop(context),
                                      cizgili: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Esnek boşluk bırakarak kartın dikey ortalanmasına yardımcı olur
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
