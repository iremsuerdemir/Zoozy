import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/add_service_rate_page.dart';
import 'package:zoozy/screens/services_rates.dart'; // Bu import'un ServiceRatesPage'i içerdiğini varsayıyoruz

class DescribeServicesPage extends StatefulWidget {
  const DescribeServicesPage({super.key});

  @override
  State<DescribeServicesPage> createState() => _DescribeServicesPageState();
}

class _DescribeServicesPageState extends State<DescribeServicesPage> {
  // 1. ADIM: Yakalanan hizmet adını tutacak değişken
  String _hizmetAdi = '';

  // Diğer tüm listeler ve değişkenler...
  final List<String> cinsler = [
    'Köpek',
    'Kedi',
    'Küçük Hayvan',
    'Tümünü Kabul Ediyorum',
  ];
  final List<String> boyutlar = [
    'Küçük (0-7kg)',
    'Orta (7-18kg)',
    'Büyük (18-45kg)',
    'Çok Büyük (45+kg)',
  ];
  final List<String> denetimSeviyeleri = [
    'Sürekli Gözetim',
    'Sık Gözetim',
    'Ara sıra Gözetim',
  ];
  final List<String> evTipleri = ['Apartman', 'Müstakil Ev', 'Çiftlik Evi'];
  final List<String> alanBoyutlari = [
    'Küçük (Balkon/Teras)',
    'Orta (Küçük Bahçe)',
    'Büyük (Geniş Bahçe)',
    'Dış Alan Yok',
  ];
  final List<String> molaSayilari = ['1-2', '3-4', '5+', 'İhtiyaç Halinde'];
  final List<String> yuruyusSayilari = ['1', '2', '3+'];
  final List<String> uykuAlanlari = [
    'Özel Oda',
    'Ev İçinde Serbest',
    'Kafes/Kulübe',
  ];
  final List<String> evDisiKonumlar = ['Kafes', 'Oyun Alanı', 'Güvenli Oda'];
  final List<String> evetHayir = ['Evet', 'Hayır'];

  String? secilenEvcilHayvanSayisi;
  String? secilenCins;
  String? secilenBoyut;
  String? secilenDenetim;
  String? secilenEvTipi;
  String? secilenDisAlanBoyutu;
  String? secilenAcilDurumAraci;
  String? secilenUykuAlani;
  String? secilenMolaSayisi;
  String? secilenYuruyusSayisi;
  String? secilenEvDisiKonum;
  String? secilenSonDakika;
  bool butonAktifMi = false;

  // 2. ADIM: Gelen argümanı yakala
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('serviceName')) {
      // serviceName'i al ve state'e kaydet
      _hizmetAdi = args['serviceName'] as String;
    }
    // Kontrol: Eğer hizmet adı hala boşsa, AboutMePage'den doğru gelmemiş demektir.
    if (_hizmetAdi.isEmpty) {
      // Hata ayıklama veya varsayılan değer ataması
      _hizmetAdi = 'Seçilen Hizmet';
    }
  }

  void _kontrolButonDurumu() {
    setState(() {
      butonAktifMi = secilenEvcilHayvanSayisi != null &&
          secilenCins != null &&
          secilenBoyut != null &&
          secilenDenetim != null &&
          secilenEvTipi != null &&
          secilenDisAlanBoyutu != null &&
          secilenAcilDurumAraci != null &&
          secilenUykuAlani != null &&
          secilenMolaSayisi != null &&
          secilenYuruyusSayisi != null &&
          secilenEvDisiKonum != null;
    });
  }

  Widget _olusturDropdown<T>({
    required String baslik,
    required List<T> elemanlar,
    required T? seciliDeger,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            value: seciliDeger,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
            isExpanded: true,
            items: elemanlar
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              onChanged(val);
              _kontrolButonDurumu();
            },
          ),
        ],
      ),
    );
  }

  Widget _olusturMetinAlani({
    required String baslik,
    required String ipucu,
    int maxSatir = 1,
    String? altYazi,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (altYazi != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Text(
                altYazi,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          TextFormField(
            maxLines: maxSatir,
            decoration: InputDecoration(
              hintText: ipucu,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ],
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
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Hizmetini Tanımla',
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
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _olusturMetinAlani(
                                  baslik: 'İlan Özeti',
                                  altYazi:
                                      'Sunduğunuz hizmetlere dair genel bir bakış sunun. (Hizmet Adı: $_hizmetAdi)',
                                  ipucu: 'Buraya ilan özetinizi girin...',
                                  maxSatir: 6,
                                ),

                                // Dropdown'lar
                                // Evcil Hayvan Sayısı
                                _olusturDropdown<String>(
                                  baslik:
                                      'Aynı anda evinizde kaç evcil hayvana bakabilirsiniz?',
                                  elemanlar: const ['1', '2', '3', '4+'],
                                  seciliDeger: secilenEvcilHayvanSayisi,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenEvcilHayvanSayisi = val;
                                      // _kontrolButonDurumu() zaten _olusturDropdown içinde çağrılıyor
                                    });
                                  },
                                ),
                                // Cins
                                _olusturDropdown<String>(
                                  baslik:
                                      'Hangi evcil hayvanları kabul ediyorsunuz?',
                                  elemanlar: cinsler,
                                  seciliDeger: secilenCins,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenCins = val;
                                    });
                                  },
                                ),
                                // Boyut
                                _olusturDropdown<String>(
                                  baslik:
                                      'Kabul ettiğiniz evcil hayvanların boyutu nedir?',
                                  elemanlar: boyutlar,
                                  seciliDeger: secilenBoyut,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenBoyut = val;
                                    });
                                  },
                                ),
                                // Denetim
                                _olusturDropdown<String>(
                                  baslik:
                                      'Ne düzeyde yetişkin gözetimi sağlayacaksınız?',
                                  elemanlar: denetimSeviyeleri,
                                  seciliDeger: secilenDenetim,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenDenetim = val;
                                    });
                                  },
                                ),
                                // Ev Dışı Konum
                                _olusturDropdown<String>(
                                  baslik:
                                      'Evinizde gözetimsiz bırakılırlarsa evcil hayvanlar nerede olacaklar?',
                                  elemanlar: evDisiKonumlar,
                                  seciliDeger: secilenEvDisiKonum,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenEvDisiKonum = val;
                                    });
                                  },
                                ),
                                // Ev Tipi
                                _olusturDropdown<String>(
                                  baslik: 'Yaşadığınız evi en iyi ne tanımlar?',
                                  elemanlar: evTipleri,
                                  seciliDeger: secilenEvTipi,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenEvTipi = val;
                                    });
                                  },
                                ),
                                // Dış Alan Boyutu
                                _olusturDropdown<String>(
                                  baslik:
                                      'Dış alanınızın (bahçe vb.) boyutu nedir?',
                                  elemanlar: alanBoyutlari,
                                  seciliDeger: secilenDisAlanBoyutu,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenDisAlanBoyutu = val;
                                    });
                                  },
                                ),
                                // Acil Durum Aracı
                                _olusturDropdown<String>(
                                  baslik:
                                      'Acil durumlar için aracınız (ulaşımınız) var mı?',
                                  elemanlar: evetHayir,
                                  seciliDeger: secilenAcilDurumAraci,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenAcilDurumAraci = val;
                                    });
                                  },
                                ),
                                // Uyku Alanı
                                _olusturDropdown<String>(
                                  baslik:
                                      'Evcil hayvanlar gece nerede uyuyacaklar?',
                                  elemanlar: uykuAlanlari,
                                  seciliDeger: secilenUykuAlani,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenUykuAlani = val;
                                    });
                                  },
                                ),
                                // Mola Sayısı
                                _olusturDropdown<String>(
                                  baslik:
                                      'Günde kaç tuvalet molası sağlayabilirsiniz?',
                                  elemanlar: molaSayilari,
                                  seciliDeger: secilenMolaSayisi,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenMolaSayisi = val;
                                    });
                                  },
                                ),
                                // Yürüyüş Sayısı
                                _olusturDropdown<String>(
                                  baslik:
                                      'Günde kaç yürüyüş sağlayabilirsiniz?',
                                  elemanlar: yuruyusSayilari,
                                  seciliDeger: secilenYuruyusSayisi,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenYuruyusSayisi = val;
                                    });
                                  },
                                ),
                                // Son Dakika
                                _olusturDropdown<String>(
                                  baslik:
                                      'Son dakika rezervasyonlarına izin veriyor musunuz?',
                                  elemanlar: evetHayir,
                                  seciliDeger: secilenSonDakika,
                                  onChanged: (val) {
                                    setState(() {
                                      secilenSonDakika = val;
                                    });
                                  },
                                ),

                                // Tercih Edilen Arama Konumu
                                _olusturMetinAlani(
                                  baslik:
                                      'Tercih Edilen Arama Konumu (İsteğe Bağlı)',
                                  altYazi:
                                      'Hizmetlerinizi arayan kişilerin sizi bulmasını istediğiniz bir dönüm noktası, önemli bir konum veya alan girin.',
                                  ipucu:
                                      'Bir dönüm noktası, önemli bir konum veya alan girin',
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: double.infinity,
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: butonAktifMi
                        ? () {
                            // 3. ADIM: ServiceRatesPage'e yönlendir ve HİZMET ADINI İLET
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ServiceRatesPage(
                                  initialServiceName:
                                      _hizmetAdi, // Hizmet adını doğru şekilde iletiyoruz
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          butonAktifMi ? const Color(0xFF8e44ad) : Colors.grey,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'SONRAKİ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
