import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoozy/screens/confirm_phone_screen.dart'; // Yeni eklendi
import 'package:zoozy/screens/identification_document_page.dart';
import 'confirm_email_screen.dart';

class MyBadgetsScreen extends StatefulWidget {
  const MyBadgetsScreen({super.key});

  @override
  State<MyBadgetsScreen> createState() => _MyBadgetsScreenState();
}

class _MyBadgetsScreenState extends State<MyBadgetsScreen> {
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false; // Yeni eklendi
  bool _isIdVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    // Telefon ve Kimlik doğrulamaları için başlangıç kontrolleri buraya eklenebilir.
    // Ancak Firebase'de telefon doğrulaması farklı bir yapı gerektirdiği için
    // şimdilik varsayılan değerler kullanıldı, siz ihtiyacınıza göre düzenleyebilirsiniz.
  }

  Future<void> _checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Güncel veriyi al
      setState(() {
        _isEmailVerified = user.emailVerified;
      });
    }
  }

  // Sadece örnek amaçlı bir metot, gerçek bir kontrol mekanizması gerektirir.
  Future<void> _checkPhoneVerification() async {
    // Gerçek telefon doğrulaması kontrol mantığı buraya gelir (örneğin bir API çağrısı).
    // Şimdilik state'i manuel olarak güncelleyelim.
    // Eğer ConfirmPhoneScreen'den başarılı sonuç dönerse güncellenecektir.
  }

  // Sadece örnek amaçlı bir metot, gerçek bir kontrol mekanizması gerektirir.
  Future<void> _checkIdVerification() async {
    // Gerçek kimlik doğrulaması kontrol mantığı buraya gelir.
    // Eğer IdentificationDocumentPage'den başarılı sonuç dönerse güncellenecektir.
  }

  @override
  Widget build(BuildContext context) {
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
                    horizontal: 16.0,
                    vertical: 8.0,
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
                        'Rozetlerim',
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
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth = math.min(
                        constraints.maxWidth * 0.92,
                        900,
                      );
                      return Center(
                        child: Container(
                          width: maxWidth,
                          padding: const EdgeInsets.all(16.0),
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
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                // E-posta Rozeti
                                InkWell(
                                  onTap: _isEmailVerified
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ConfirmEmailScreen(
                                                    email:
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.email ??
                                                        '',
                                                  ),
                                            ),
                                          ).then(
                                            (_) => _checkEmailVerification(),
                                          );
                                        },
                                  child: RozetItem(
                                    icon: Icons.mail_outline,
                                    baslik: 'E-posta',
                                    durumMetni: _isEmailVerified
                                        ? 'Doğrulandı'
                                        : 'Şimdi Doğrula',
                                    durumRengi: _isEmailVerified
                                        ? Colors.green
                                        : Colors.black54,
                                    trailingIcon: _isEmailVerified
                                        ? Icons.verified
                                        : null,
                                    trailingIconColor: _isEmailVerified
                                        ? Colors.green
                                        : null,
                                  ),
                                ),

                                // Telefon Rozeti (Yeni Eklendi)
                                InkWell(
                                  onTap: _isPhoneVerified
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ConfirmPhoneScreen(),
                                            ),
                                          ).then((result) {
                                            if (result == true) {
                                              setState(() {
                                                _isPhoneVerified = true;
                                              });
                                            }
                                            _checkPhoneVerification(); // İsteğe bağlı olarak kontrolü tekrar çağır
                                          });
                                        },
                                  child: RozetItem(
                                    icon: Icons.phone_android,
                                    baslik: 'Telefon',
                                    durumMetni: _isPhoneVerified
                                        ? 'Doğrulandı'
                                        : 'Şimdi Doğrula',
                                    durumRengi: _isPhoneVerified
                                        ? Colors.green
                                        : Colors.black54,
                                    trailingIcon: _isPhoneVerified
                                        ? Icons.verified
                                        : null,
                                    trailingIconColor: _isPhoneVerified
                                        ? Colors.green
                                        : null,
                                  ),
                                ),

                                // Kimlik Rozeti
                                InkWell(
                                  onTap: _isIdVerified
                                      ? null
                                      : () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const IdentificationDocumentPage(),
                                            ),
                                          );
                                          if (result == true) {
                                            setState(() {
                                              _isIdVerified = true;
                                            });
                                          }
                                          _checkIdVerification(); // İsteğe bağlı olarak kontrolü tekrar çağır
                                        },
                                  child: RozetItem(
                                    icon: Icons.person_outline,
                                    baslik: 'Kimlik Doğrulaması',
                                    durumMetni: _isIdVerified
                                        ? 'Doğrulandı'
                                        : 'Şimdi Doğrula',
                                    durumRengi: _isIdVerified
                                        ? Colors.green
                                        : Colors.black54,
                                    trailingIcon: _isIdVerified
                                        ? Icons.verified
                                        : null,
                                    trailingIconColor: _isIdVerified
                                        ? Colors.green
                                        : null,
                                  ),
                                ),

                                // Diğer Rozetler (sabit örnekler)
                                RozetItem(
                                  icon: Icons.facebook,
                                  baslik: 'Facebook',
                                  durumMetni: 'Doğrulandı',
                                  durumRengi: Colors.green,
                                  trailingIcon: Icons.verified,
                                  trailingIconColor: Colors.green,
                                ),
                                RozetItem(
                                  icon: Icons.account_circle_outlined,
                                  baslik: 'Google',
                                  durumMetni: 'Doğrulandı',
                                  durumRengi: Colors.green,
                                  trailingIcon: Icons.verified,
                                  trailingIconColor: Colors.green,
                                ),
                                RozetItem(
                                  icon: Icons.assignment_turned_in_outlined,
                                  baslik: 'Sertifikalar',
                                  durumMetni: 'Şimdi Doğrula',
                                  durumRengi: Colors.black54,
                                ),
                                RozetItem(
                                  icon: Icons.work_outline,
                                  baslik: 'İşletme Lisansı',
                                  durumMetni: 'Şimdi Doğrula',
                                  durumRengi: Colors.black54,
                                ),
                                RozetItem(
                                  icon: Icons.fingerprint,
                                  baslik: 'Adli Sicil Belgesi',
                                  durumMetni: 'Şimdi Doğrula',
                                  durumRengi: Colors.black54,
                                ),

                                const SizedBox(height: 16),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    'Profilini doğrulatarak güven kazan! Diğer kullanıcılar seninle daha kolay iletişime geçebilir.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RozetItem extends StatelessWidget {
  final IconData icon;
  final String baslik;
  final String durumMetni;
  final Color durumRengi;
  final IconData? trailingIcon;
  final Color? trailingIconColor;

  const RozetItem({
    super.key,
    required this.icon,
    required this.baslik,
    required this.durumMetni,
    required this.durumRengi,
    this.trailingIcon,
    this.trailingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(color: Colors.grey.shade300, width: 0.8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE7F6),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(icon, color: const Color(0xFF6A1B9A), size: 24),
          ),
          title: Text(
            baslik,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            durumMetni,
            style: TextStyle(
              color: durumRengi,
              fontSize: 14,
              fontWeight: (durumMetni.contains('Doğrulandı'))
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
          trailing: trailingIcon != null
              ? Icon(trailingIcon, color: trailingIconColor, size: 24)
              : null,
        ),
      ),
    );
  }
}
