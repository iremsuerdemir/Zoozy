import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/screens/certification_screen.dart';
import 'package:zoozy/screens/confirm_email_screen.dart';
import 'package:zoozy/screens/confirm_phone_screen.dart';
import 'package:zoozy/screens/identification_document_page.dart';

class MyBadgetsScreen extends StatefulWidget {
  final bool phoneVerified;
  const MyBadgetsScreen({super.key, required this.phoneVerified});

  @override
  State<MyBadgetsScreen> createState() => _MyBadgetsScreenState();
}

class _MyBadgetsScreenState extends State<MyBadgetsScreen> {
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;
  bool _isIdVerified = false;
  bool _isCertificatesVerified = false;
  bool _isBusinessLicenseVerified = false;
  bool _isCriminalRecordVerified = false;

  @override
  void initState() {
    super.initState();
    _isPhoneVerified = widget.phoneVerified;
    _checkEmailVerification();
    _loadSavedStatuses();
  }

  Future<void> _checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() => _isEmailVerified = user.emailVerified);
    }
  }

  Future<void> _checkPhoneVerification() async {}
  Future<void> _checkIdVerification() async {}

  Future<void> _loadSavedStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBusinessLicenseVerified = prefs.getBool('business_license') ?? false;
      _isCriminalRecordVerified = prefs.getBool('criminal_record') ?? false;
      _isIdVerified =
          prefs.getBool('id_verification') ?? prefs.getBool('id') ?? false;
      _isCertificatesVerified = prefs.getBool('certificates_verified') ?? false;
      _isPhoneVerified = prefs.getBool('phone_verified') ?? _isPhoneVerified;
    });
  }

  Future<void> _saveStatus(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool?> _dosyaSecPopup(String belgeTipi, String prefKey) async {
    final ImagePicker _picker = ImagePicker();
    return showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$belgeTipi Yükle",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text("Galeriden Seç"),
                onTap: () async {
                  final picked = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (picked != null) {
                    await _saveStatus(prefKey, true);
                    Navigator.pop(context, true);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Fotoğraf Çek"),
                onTap: () async {
                  final picked = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (picked != null) {
                    await _saveStatus(prefKey, true);
                    Navigator.pop(context, true);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text("PDF Seç"),
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null && result.files.isNotEmpty) {
                    await _saveStatus(prefKey, true);
                    Navigator.pop(context, true);
                  }
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Kapat",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
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
                          padding: const EdgeInsets.all(16),
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
                                // Rozetler
                                RozetItem(
                                  icon: Icons.mail_outline,
                                  baslik: 'E-posta',
                                  durumMetni: _isEmailVerified
                                      ? 'Doğrulandı'
                                      : 'Şimdi Doğrula',
                                  durumRengi: _isEmailVerified
                                      ? Colors.green
                                      : Colors.black54,
                                  trailingIcon:
                                      _isEmailVerified ? Icons.verified : null,
                                  trailingIconColor:
                                      _isEmailVerified ? Colors.green : null,
                                  onTap: _isEmailVerified
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ConfirmEmailScreen(
                                                email: FirebaseAuth.instance
                                                        .currentUser?.email ??
                                                    '',
                                              ),
                                            ),
                                          ).then(
                                            (_) => _checkEmailVerification(),
                                          );
                                        },
                                ),
                                RozetItem(
                                  icon: Icons.phone_android,
                                  baslik: 'Telefon',
                                  durumMetni: _isPhoneVerified
                                      ? 'Doğrulandı'
                                      : 'Şimdi Doğrula',
                                  durumRengi: _isPhoneVerified
                                      ? Colors.green
                                      : Colors.black54,
                                  trailingIcon:
                                      _isPhoneVerified ? Icons.verified : null,
                                  trailingIconColor:
                                      _isPhoneVerified ? Colors.green : null,
                                  onTap: _isPhoneVerified
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const ConfirmPhoneScreen(),
                                            ),
                                          ).then((result) {
                                            if (result == true)
                                              setState(
                                                () => _isPhoneVerified = true,
                                              );
                                            if (result == true) {
                                              _saveStatus(
                                                  'phone_verified', true);
                                            }
                                            _checkPhoneVerification();
                                          });
                                        },
                                ),
                                RozetItem(
                                  icon: Icons.person_outline,
                                  baslik: 'Kimlik Doğrulaması',
                                  durumMetni: _isIdVerified
                                      ? 'Doğrulandı'
                                      : 'Şimdi Doğrula',
                                  durumRengi: _isIdVerified
                                      ? Colors.green
                                      : Colors.black54,
                                  trailingIcon:
                                      _isIdVerified ? Icons.verified : null,
                                  trailingIconColor:
                                      _isIdVerified ? Colors.green : null,
                                  onTap: _isIdVerified
                                      ? null
                                      : () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const IdentificationDocumentPage(),
                                            ),
                                          );
                                          if (result == true)
                                            setState(
                                              () => _isIdVerified = true,
                                            );
                                          if (result == true) {
                                            _saveStatus(
                                                'id_verification', true);
                                          }
                                          _checkIdVerification();
                                        },
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
                                  durumMetni: _isCertificatesVerified
                                      ? 'Doğrulandı'
                                      : 'Şimdi Doğrula',
                                  durumRengi: _isCertificatesVerified
                                      ? Colors.green
                                      : Colors.black54,
                                  trailingIcon: _isCertificatesVerified
                                      ? Icons.verified
                                      : null,
                                  trailingIconColor: _isCertificatesVerified
                                      ? Colors.green
                                      : null,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CertificationScreen(),
                                      ),
                                    ).then((result) {
                                      if (result == true)
                                        setState(
                                          () => _isCertificatesVerified = true,
                                        );
                                      if (result == true) {
                                        _saveStatus(
                                            'certificates_verified', true);
                                      }
                                    });
                                  },
                                ),
                                RozetItem(
                                  icon: Icons.work_outline,
                                  baslik: 'İşletme Lisansı',
                                  durumMetni: _isBusinessLicenseVerified
                                      ? 'Doğrulandı'
                                      : 'Şimdi Doğrula',
                                  durumRengi: _isBusinessLicenseVerified
                                      ? Colors.green
                                      : Colors.black54,
                                  trailingIcon: _isBusinessLicenseVerified
                                      ? Icons.verified
                                      : null,
                                  trailingIconColor: _isBusinessLicenseVerified
                                      ? Colors.green
                                      : null,
                                  onTap: () async {
                                    final result = await _dosyaSecPopup(
                                      'İşletme Lisansı',
                                      'business_license',
                                    );
                                    if (result == true)
                                      setState(
                                        () => _isBusinessLicenseVerified = true,
                                      );
                                  },
                                ),
                                RozetItem(
                                  icon: Icons.fingerprint,
                                  baslik: 'Adli Sicil Belgesi',
                                  durumMetni: _isCriminalRecordVerified
                                      ? 'Doğrulandı'
                                      : 'Şimdi Doğrula',
                                  durumRengi: _isCriminalRecordVerified
                                      ? Colors.green
                                      : Colors.black54,
                                  trailingIcon: _isCriminalRecordVerified
                                      ? Icons.verified
                                      : null,
                                  trailingIconColor: _isCriminalRecordVerified
                                      ? Colors.green
                                      : null,
                                  onTap: () async {
                                    final result = await _dosyaSecPopup(
                                      'Adli Sicil Belgesi',
                                      'criminal_record',
                                    );
                                    if (result == true)
                                      setState(
                                        () => _isCriminalRecordVerified = true,
                                      );
                                  },
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
  final VoidCallback? onTap;

  const RozetItem({
    super.key,
    required this.icon,
    required this.baslik,
    required this.durumMetni,
    required this.durumRengi,
    this.trailingIcon,
    this.trailingIconColor,
    this.onTap,
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
          onTap: onTap,
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
