import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/screens/my_badgets_screen.dart';

class CertificationScreen extends StatefulWidget {
  const CertificationScreen({super.key});

  @override
  State<CertificationScreen> createState() => _CertificationScreenState();
}

class _CertificationScreenState extends State<CertificationScreen> {
  final ImagePicker _picker = ImagePicker();

  // Sertifikaların durumu (true = yüklendi)
  Map<String, bool> sertifikaTikDurumu = {
    'Egitmen': false,
    'Bakim': false,
    'Veteriner': false,
  };

  @override
  void initState() {
    super.initState();
    _loadStatus(); // Daha önce yüklenmiş sertifikaları oku
  }

  // SharedPreferences'tan durumu yükle
  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sertifikaTikDurumu.forEach((key, _) {
        sertifikaTikDurumu[key] = prefs.getBool(key) ?? false;
      });
    });
  }

  // Arka plan
  Widget _arkaplan() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
        ),
      ),
    );
  }

  // Üst başlık
  Widget _ustBaslik(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () {
              bool tumuTikli = !sertifikaTikDurumu.values.contains(false);
              Navigator.pop(context, tumuTikli);
            },
          ),
          const Text(
            'Sertifikalar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // Sertifika kartı
  Widget _sertifikaKarti({required String baslik, required String tip}) {
    final bool yuklendi = sertifikaTikDurumu[tip] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () => _dosyaSec(tip),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // Hatalı SizedBox(10); satırı kaldırıldı.
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start, // Tüm öğeleri sola yaslar
            children: [
              _ikonGetir(tip),

              // İkon ile başlık arasına 16 birim boşluk
              const SizedBox(width: 16),

              // Başlık metni
              Text(
                baslik,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),

              // **Spacer** metin ile sonraki öğe (tik işareti) arasına olabilecek en fazla boşluğu ekleyerek tik işaretini en sağa iter.
              const Spacer(),

              // Onay işareti
              if (yuklendi)
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  // Sertifika ikonları
  Widget _ikonGetir(String tip) {
    Color renk = const Color(0xFF9C27B0);
    double boyut = 32;

    switch (tip) {
      case 'Egitmen':
        return Icon(Icons.auto_awesome, size: boyut, color: renk);
      case 'Bakim':
        return Transform.rotate(
          angle: -math.pi / 4,
          child: Icon(Icons.content_cut, size: boyut, color: renk),
        );
      case 'Veteriner':
        return Icon(Icons.person_pin, size: boyut, color: renk);
      default:
        return Icon(Icons.help_outline, size: boyut, color: renk);
    }
  }

  // Dosya seçme popup (resim veya PDF)
  Future<void> _dosyaSec(String tip) async {
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
                  "$tip Sertifikası Yükle",
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
                    Navigator.pop(context);
                    final picked = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      setState(() {
                        sertifikaTikDurumu[tip] = true;
                      });
                      _saveStatus(tip, true);
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
                        sertifikaTikDurumu[tip] = true;
                      });
                      _saveStatus(tip, true);
                    }
                  },
                ),
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
                      setState(() {
                        sertifikaTikDurumu[tip] = true;
                      });
                      _saveStatus(tip, true);
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

  // SharedPreferences kaydetme
  Future<void> _saveStatus(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);

    // Eğer tüm sertifikalar yüklendiyse MyBadgetsScreen'e true dön
    if (!sertifikaTikDurumu.values.contains(false)) {
      Navigator.pop(context, true);
    }
  }

  // İçerik gövdesi
  Widget _icerikGovde() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = math.min(constraints.maxWidth * 0.9, 900);

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
                  _sertifikaKarti(
                    baslik: 'Eğitmen Sertifikası',
                    tip: 'Egitmen',
                  ),
                  _sertifikaKarti(baslik: 'Bakım Sertifikası', tip: 'Bakim'),
                  _sertifikaKarti(
                    baslik: 'Veteriner Sertifikası',
                    tip: 'Veteriner',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _arkaplan(),
          SafeArea(
            child: Column(
              children: [
                _ustBaslik(context),
                const SizedBox(height: 16),
                _icerikGovde(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
