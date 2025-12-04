import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Sabit Renkler ---
const Color kAnaMor = Color(0xFF8C60A8);
const Color kAcikMor = Color(0xFFF0EAF5);
const Color kKoyuYazi = Color(0xFF4C4C4C);

// --- ForgotPassword Widget (Kullanıcının sağladığı kod) ---
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  // Yükleme durumunu yönetmek için
  bool _isLoading = false;

  // Hata ve başarı mesajlarını göstermek için yardımcı fonksiyon
  void _gosterMesaj(String metin, Color renk) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: renk,
          content: Text(
            metin,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  // Tekrar kullanılabilir buton oluşturma fonksiyonu
  Widget _butonOlustur({
    required String metin,
    required Color renk,
    required Color metinRengi,
    required VoidCallback tiklamaFonksiyonu,
    bool cizgili = false,
    bool disabled = false, // Buton devre dışı mı?
  }) {
    // Buton devre dışıysa rengi biraz gri yapıyoruz
    final buttonColor = disabled ? Colors.grey : renk;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          // Yükleniyorsa veya disabled true ise boş bir fonksiyon atıyoruz
          onPressed: disabled ? null : tiklamaFonksiyonu,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: metinRengi,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: cizgili
                  ? const BorderSide(color: kAnaMor, width: 2)
                  : BorderSide.none,
            ),
            elevation: 5,
          ),
          child: _isLoading && (metin == 'ŞİFRE SIFIRLA')
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  metin,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  // Şifre sıfırlama butonuna tıklandığında çalışacak ASENKRON fonksiyon
  void _sifirlamaLinkiniGonder() async {
    // Form doğrulamasını kontrol et
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Yükleme durumunu başlat
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase Auth metodu çağrılıyor
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      // Başarılı olduğunda dialog göster
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Şifre Sıfırlama'),
              content: const Text(
                'Şifre sıfırlama linki e-posta adresinize gönderildi.\n\nLütfen gelen kutunuzu kontrol edin ve linke tıklayın.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Dialog kapat
                    Navigator.pop(context); // Forgot Password sayfasından çık
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      // Hata yakalama ve kullanıcıya özel mesaj gösterme
      String hataMesaji;

      switch (e.code) {
        case 'user-not-found':
          hataMesaji = 'Bu e-posta adresiyle kayıtlı bir kullanıcı bulunamadı.';
          break;
        case 'invalid-email':
          hataMesaji = 'Lütfen geçerli bir e-posta adresi girin.';
          break;
        case 'firebase_auth/network-request-failed':
        case 'network-request-failed':
          hataMesaji = 'İnternet bağlantınızı kontrol edin.';
          break;
        default:
          hataMesaji = 'Bir hata oluştu: ${e.message ?? 'Bilinmeyen Hata'}';
          break;
      }

      _gosterMesaj(hataMesaji, Colors.red); // Hata mesajını kırmızı göster
    } finally {
      // İşlem bittiğinde yükleme durumunu kapat
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white, size: 28),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.pets,
                                      color: Colors.white, size: 30),
                                  SizedBox(width: 8),
                                  Text(
                                    'Zoozy',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 48),
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
                                      metin: 'ŞİFRE SIFIRLA',
                                      renk: kAnaMor,
                                      metinRengi: Colors.white,
                                      tiklamaFonksiyonu:
                                          _sifirlamaLinkiniGonder,
                                      disabled: _isLoading,
                                    ),
                                    const SizedBox(height: 15),
                                    _butonOlustur(
                                      metin: 'GERİ',
                                      renk: Colors.white,
                                      metinRengi: Colors.grey,
                                      tiklamaFonksiyonu: () =>
                                          Navigator.pop(context),
                                      cizgili: true,
                                      disabled:
                                          _isLoading, // Geri butonu da yüklenirken devre dışı kalsın
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

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
