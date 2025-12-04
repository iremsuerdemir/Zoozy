import 'dart:io';
import 'dart:math' as math;
import 'dart:convert'; // Base64 encoding/decoding için
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/screens/profile_screen.dart';

// Byte verilerini ve yolu tutmak için sınıf
class _PhotoData {
  final String path;
  final Uint8List? bytes;

  _PhotoData(this.path, this.bytes);
}

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  int _mevcutAdim = 0;
  // SharedPreferences'ta saklanacak olan Base64 veya Dosya Yolu listeleri
  List<String> _hayvanFotoKayitlari = [];
  List<String> _evFotoKayitlari = [];

  // Görselde anlık gösterim için kullanılan List
  List<_PhotoData> _hayvanFotograflari = [];
  List<_PhotoData> _evFotograflari = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fotograflariYukle();
  }

  // Yükleme metodu Base64/Path ayrımını yapacak şekilde güncellendi
  Future<void> _fotograflariYukle() async {
    final prefs = await SharedPreferences.getInstance();

    // Kayıt listelerinin adları güncellendi
    _hayvanFotoKayitlari = prefs.getStringList('hayvanFotoKayitlari') ?? [];
    _evFotoKayitlari = prefs.getStringList('evFotoKayitlari') ?? [];

    List<_PhotoData> yuklenenHayvanFotolari = [];
    List<_PhotoData> yuklenenEvFotolari = [];

    // KAYITLARDAN _PhotoData oluşturma
    for (String kayit in _hayvanFotoKayitlari) {
      yuklenenHayvanFotolari.add(_kayitlariPhotoDataCevir(kayit));
    }
    for (String kayit in _evFotoKayitlari) {
      yuklenenEvFotolari.add(_kayitlariPhotoDataCevir(kayit));
    }

    setState(() {
      _hayvanFotograflari = yuklenenHayvanFotolari;
      _evFotograflari = yuklenenEvFotolari;
    });
  }

  // Kayıt String'ini (_PhotoData'ya çeviren yardımcı metot)
  _PhotoData _kayitlariPhotoDataCevir(String kayit) {
    if (kIsWeb) {
      // Web'de: Base64 string'i byte dizisine çevir
      try {
        Uint8List bytes = base64Decode(kayit);
        return _PhotoData(kayit, bytes);
      } catch (e) {
        // Hata olursa (bozuk Base64), sadece path/kaydı tut
        return _PhotoData(kayit, null);
      }
    } else {
      // Mobil/Masaüstü: Path'i tut
      return _PhotoData(kayit, null); // Path'i tut, Image.file() ile okunacak
    }
  }

  Future<void> _fotoYukle() async {
    final XFile? secilenFoto = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (secilenFoto == null) return;

    final yol = secilenFoto.path;
    Uint8List bytes =
        await secilenFoto.readAsBytes(); // Her zaman byte verisini oku
    String kayitVerisi;

    if (kIsWeb) {
      // Web'de Base64 olarak kaydet
      kayitVerisi = base64Encode(bytes);
    } else {
      // Mobil/Masaüstü'nde dosya yolunu kaydet
      kayitVerisi = yol;
    }

    final yeniFoto = _PhotoData(kayitVerisi, bytes);

    setState(() {
      if (_mevcutAdim == 0) {
        _hayvanFotoKayitlari.add(kayitVerisi);
        _hayvanFotograflari.add(yeniFoto);
      } else {
        _evFotoKayitlari.add(kayitVerisi);
        _evFotograflari.add(yeniFoto);
      }
    });

    final prefs = await SharedPreferences.getInstance();
    bool saveSuccess = false;

    // Web'e özgü kalıcılık kontrolü
    if (_mevcutAdim == 0) {
      saveSuccess = await prefs.setStringList(
        'hayvanFotoKayitlari',
        _hayvanFotoKayitlari,
      );
    } else {
      saveSuccess = await prefs.setStringList(
        'evFotoKayitlari',
        _evFotoKayitlari,
      );
    }

    // Base64 verisi çok büyükse ve kaydedilemezse uyarı göster
    if (kIsWeb && !saveSuccess) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "UYARI: Resim kalıcı olarak kaydedilemedi (Depolama Limiti Aşıldı). Uygulamayı yeniden başlattığınızda kaybolabilir.",
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 6),
        ),
      );
    }
  }

  Future<void> _fotoSil(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_mevcutAdim == 0) {
        _hayvanFotoKayitlari.removeAt(index);
        _hayvanFotograflari.removeAt(index);
        prefs.setStringList('hayvanFotoKayitlari', _hayvanFotoKayitlari);
      } else {
        _evFotoKayitlari.removeAt(index);
        _evFotograflari.removeAt(index);
        prefs.setStringList('evFotoKayitlari', _evFotoKayitlari);
      }
    });
  }

  void _ileri() {
    if (_mevcutAdim == 0) {
      setState(() => _mevcutAdim = 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tüm fotoğraflar başarıyla yüklendi! 🎉"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // 1 saniye bekleyip ProfileScreen'e yönlendir
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      });
    }
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () {
              if (_mevcutAdim == 1) {
                setState(() => _mevcutAdim = 0);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Text(
            _mevcutAdim == 0 ? "Evcil Hayvan Fotoğrafları" : "Ev Fotoğrafları",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContentCard() {
    List<_PhotoData> mevcutFotoListesi =
        _mevcutAdim == 0 ? _hayvanFotograflari : _evFotograflari;

    String aciklama = _mevcutAdim == 0
        ? "Evcil hayvanınızla birkaç tatlı fotoğraf yükleyin 💜"
        : "Evcil hayvanların kalacağı alanın birkaç fotoğrafını yükleyin 🏡";

    return Expanded(
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
                  InkWell(
                    onTap: _fotoYukle,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    aciklama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: mevcutFotoListesi.isEmpty
                        ? const Center(
                            child: Text(
                              "Henüz fotoğraf yüklenmedi 📷",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : GridView.builder(
                            itemCount: mevcutFotoListesi.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              Widget imageWidget;
                              final fotoData = mevcutFotoListesi[index];

                              if (kIsWeb) {
                                // Web'de Base64'ten gelen bytes verisini kullan
                                if (fotoData.bytes != null) {
                                  imageWidget = Image.memory(
                                    fotoData.bytes!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  );
                                } else {
                                  // Base64 okunamadıysa veya bytes null ise kırık resim göster
                                  imageWidget = Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                // Mobil/Masaüstü'nde Image.file() kullan
                                imageWidget = Image.file(
                                  File(fotoData.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  // Mobil/Masaüstü'nde dosya silinmişse veya yol bozuksa placeholder göster
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imageWidget,
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _fotoSil(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _ileri,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.deepPurpleAccent],
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
                          "İLERİ",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildContentCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
