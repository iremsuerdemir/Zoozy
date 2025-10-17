// identification_document_page.dart

import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; // PDF için eklendi
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/screens/my_badgets_screen.dart';

class IdentificationDocumentPage extends StatefulWidget {
  const IdentificationDocumentPage({super.key});

  @override
  State<IdentificationDocumentPage> createState() =>
      _IdentificationDocumentPageState();
}

class _IdentificationDocumentPageState
    extends State<IdentificationDocumentPage> {
  final ImagePicker _picker = ImagePicker();

  // Belgelerin durumu (true = yüklendi)
  Map<String, bool> belgelerYuklendi = {
    "id": false,
    "selfie": false,
    "license": false,
    "passport": false,
    "criminal": false,
    "payment": false,
    "pdf": false, // PDF durumu eklendi
  };

  @override
  void initState() {
    super.initState();
    _loadSavedStatuses();
  }

  Future<void> _loadSavedStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      belgelerYuklendi.forEach((key, value) {
        belgelerYuklendi[key] = prefs.getBool(key) ?? false;
      });
    });
  }

  Future<void> _saveStatus(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _dosyaSec(String belgeKey) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Dosya Yükle",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                // Sadece PDF kartı için farklı seçenek
                if (belgeKey != "pdf") ...[
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: const Text("Galeriden Seç"),
                    onTap: () async {
                      Navigator.pop(context);
                      final picked = await _picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        setState(() {
                          belgelerYuklendi[belgeKey] = true;
                        });
                        _saveStatus(belgeKey, true);
                        _checkRequiredUploaded();
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: const Text("Fotoğraf Çek"),
                    onTap: () async {
                      Navigator.pop(context);
                      final picked = await _picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (picked != null) {
                        setState(() {
                          belgelerYuklendi[belgeKey] = true;
                        });
                        _saveStatus(belgeKey, true);
                        _checkRequiredUploaded();
                      }
                    },
                  ),
                ],
                // PDF seçeneği her zaman göster
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text("PDF Seç"),
                  onTap: () async {
                    Navigator.pop(context);
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                    if (result != null && result.files.isNotEmpty) {
                      // PDF dışında bir dosya seçildiyse uyarı
                      final fileName = result.files.first.name;
                      if (!fileName.toLowerCase().endsWith('.pdf')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Lütfen sadece PDF dosyası seçin."),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        belgelerYuklendi[belgeKey] = true;
                      });
                      _saveStatus(belgeKey, true);
                      _checkRequiredUploaded();
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
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
        );
      },
    );
  }

  // identification_document_page.dart içinde

  // ...

  // Tüm belgeler yüklendi mi kontrol - Sadece TÜM belgeler için true DÖNMEZ
  // Artık sadece gerekli olan belgelerin kontrolünü yapmalıyız.
  // Gerekli olan: "id"
  void _checkRequiredUploaded() {
    // Gelecekte başka gerekli belgeler de olabilir diye bir liste tutalım
    const List<String> requiredKeys = ['id'];

    // Gerekli belgelerin hepsi yüklendi mi kontrolü
    final bool requiredDocsUploaded = requiredKeys.every(
      (key) => belgelerYuklendi[key] == true,
    );

    if (requiredDocsUploaded) {
      // Gerekli olanlar yüklendiğinde MyBadgetsScreen'e true dön
      Navigator.pop(context, true);
    }
  }

  Widget _belgeKarti({
    required IconData ikon,
    required String baslik,
    required String altYazi,
    required bool gerekliMi,
    required String belgeKey,
  }) {
    final bool yuklendi = belgelerYuklendi[belgeKey] ?? false;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(ikon, color: Colors.deepPurple),
        ),
        title: Text(
          baslik,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          altYazi,
          style: TextStyle(
            color: gerekliMi ? Colors.red : Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: yuklendi
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
        onTap: () => _dosyaSec(belgeKey),
      ),
    );
  }

  Widget _dogrulamaBilgiKutusu() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Text(
        "Diğer kullanıcıların sana güvenmesi için kimliğini doğrulat.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.5),
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
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      const Text(
                        "Kimlik Belgeleri",
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
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth = math.min(
                        constraints.maxWidth * 0.9,
                        900,
                      );
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
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Gerekli Belgeler",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _belgeKarti(
                                  ikon: Icons.badge_outlined,
                                  baslik: "Kimlik Belgesi (ID)",
                                  altYazi: "Gerekli",
                                  gerekliMi: true,
                                  belgeKey: "id",
                                ),

                                const SizedBox(height: 24),
                                const Text(
                                  "İsteğe Bağlı Belgeler",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _belgeKarti(
                                  ikon: Icons.directions_car,
                                  baslik: "Sürücü Belgesi",
                                  altYazi: "Taksi hizmetleri için gerekli",
                                  gerekliMi: false,
                                  belgeKey: "license",
                                ),
                                _belgeKarti(
                                  ikon: Icons.public,
                                  baslik: "Pasaport",
                                  altYazi: "(İsteğe bağlı) Eğer kimliğin yoksa",
                                  gerekliMi: false,
                                  belgeKey: "passport",
                                ),
                                _belgeKarti(
                                  ikon: Icons.person_pin_circle_outlined,
                                  baslik: "Adli Sicil Kaydı",
                                  altYazi: "(İsteğe bağlı)",
                                  gerekliMi: false,
                                  belgeKey: "criminal",
                                ),
                                _belgeKarti(
                                  ikon: Icons.credit_card,
                                  baslik: "Ödeme Kimliği",
                                  altYazi:
                                      "(İsteğe bağlı) Ödeme bilgilerini doğrulamak için",
                                  gerekliMi: false,
                                  belgeKey: "payment",
                                ),
                                _belgeKarti(
                                  ikon: Icons.picture_as_pdf,
                                  baslik: "PDF Belgesi",
                                  altYazi: "(İsteğe bağlı) PDF dosyası yükle",
                                  gerekliMi: false,
                                  belgeKey: "pdf",
                                ),
                                const SizedBox(height: 24),
                                _dogrulamaBilgiKutusu(),
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
