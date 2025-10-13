import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'confirm_email_screen.dart';

class MyBadgetsScreen extends StatefulWidget {
  const MyBadgetsScreen({super.key});

  @override
  State<MyBadgetsScreen> createState() => _MyBadgetsScreenState();
}

class _MyBadgetsScreenState extends State<MyBadgetsScreen> {
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
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
                                const SizedBox(height: 8),
                                // Email Rozeti
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

                                // Diğer Rozetler (sabit örnek)
                                RozetItem(
                                  icon: Icons.phone_android,
                                  baslik: 'Telefon',
                                  durumMetni: 'Şimdi Doğrula',
                                  durumRengi: Colors.black54,
                                ),
                                RozetItem(
                                  icon: Icons.person_outline,
                                  baslik: 'Kimlik Doğrulaması',
                                  durumMetni: 'Şimdi Doğrula',
                                  durumRengi: Colors.black54,
                                ),
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
                                RozetItem(
                                  icon: Icons.description_outlined,
                                  baslik: 'Online Test',
                                  durumMetni: 'Şimdi Katıl',
                                  durumRengi: const Color(0xFF6A1B9A),
                                ),
                                RozetItem(
                                  icon: Icons.pets_outlined,
                                  baslik: 'Pet Sitter Tanıtım Testi',
                                  durumMetni: 'Şimdi Katıl',
                                  durumRengi: const Color(0xFF6A1B9A),
                                ),
                                RozetItem(
                                  icon: Icons.folder_open_outlined,
                                  baslik: 'Diğer Belgeler',
                                  durumMetni:
                                      'Doğrulama Bekleyen: 0\nDoğrulanmış Belgeler: 0',
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
