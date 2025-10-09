import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/describe_services_page.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  String? _secilenYetenek;
  final TextEditingController _kendiniController = TextEditingController();
  final TextEditingController _deneyimController = TextEditingController();
  final TextEditingController _ozelController = TextEditingController();

  // 1. ADIM: Yakalanan hizmet adını tutacak değişken
  String _hizmetAdi = '';

  final List<String> _yetenekler = [
    'Eğitim deneyimi',
    'Davranış eğitimi becerisi',
    'Evcil hayvanların ruh halini anlayabilme',
    'İlaç uygulama bilgisi',
    'Veterinerlik deneyimi',
    'Evcil hayvan bakımı bilgisi',
    'Kuaförlük (Grooming) sertifikası',
  ];

  bool get _formDolu =>
      _kendiniController.text.isNotEmpty &&
      _deneyimController.text.isNotEmpty &&
      _ozelController.text.isNotEmpty &&
      _secilenYetenek != null;

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
  }

  @override
  void dispose() {
    _kendiniController.dispose();
    _deneyimController.dispose();
    _ozelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color anaMor = Color(0xFF9C27B0);
    const Color gradientStart = Color(0xFFB39DDB);
    const Color gradientEnd = Color(0xFFF48FB1);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst bar
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
                      'Hakkımda',
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
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
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
                              const SizedBox(height: 6),

                              // Kendini Tanıt
                              const Text(
                                'Kendini tanıt ve neden evcil hayvanlarla vakit geçirmekten hoşlandığını anlat.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _OzellesmisTextField(
                                controller: _kendiniController,
                                hintText:
                                    "Örneğin: Ben bir hayvanseverim, çünkü evcil hayvanlar çok sevimli ve huzur verici.",
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 20),

                              // Evcil hayvan deneyimi
                              const Text(
                                'Sahip olduğun evcil hayvan(lar)dan ve onlarla olan deneyiminden bahset.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _OzellesmisTextField(
                                controller: _deneyimController,
                                hintText:
                                    "Örneğin: 18 yaşından beri bir Alman kurdum var. Harika bir dost ve ailemi koruyor. Onunla yürüyüşe çıkmayı ve birlikte uyumayı çok seviyorum.",
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 20),

                              // Dropdown Yetenekler
                              _yetenekDropdown(anaMor),
                              const SizedBox(height: 20),

                              // Diğer özel beceriler
                              const Text(
                                'Evcil hayvanlarla ilgili başka özel becerilerin veya sertifikaların var mı?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _OzellesmisTextField(
                                controller: _ozelController,
                                hintText:
                                    "Eğitim, kuaförlük veya sertifika gibi deneyimlerinden bahsedebilirsin.",
                                minLines: 5,
                                maxLines: 5,
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 25),

                              // Kaydet Butonu
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: _formDolu
                                      ? const LinearGradient(
                                          colors: [
                                            anaMor,
                                            Colors.deepPurpleAccent,
                                          ],
                                        )
                                      : null,
                                  color: !_formDolu
                                      ? Colors.grey.shade400
                                      : null,
                                ),
                                child: ElevatedButton(
                                  onPressed: _formDolu
                                      ? () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                "Bilgiler başarıyla kaydedildi.",
                                              ),
                                            ),
                                          );

                                          // 3. ADIM: DescribeServicesPage'e yönlendir ve hizmet adını ilet
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DescribeServicesPage(),
                                              settings: RouteSettings(
                                                arguments: {
                                                  // Service adını bir sonraki sayfaya aktarıyoruz!
                                                  'serviceName': _hizmetAdi,
                                                },
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    minimumSize: const Size.fromHeight(50),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Kaydet",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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
            ],
          ),
        ),
      ),
    );
  }

  // ... (Diğer _yetenekDropdown ve _OzellesmisTextField kodları aynı kalır)

  Widget _yetenekDropdown(Color anaRenk) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yeteneklerin ve Niteliklerin',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: anaRenk, width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          ),
          value: _secilenYetenek,
          hint: const Text('Bir yetenek seç'),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          items: _yetenekler.map((String yetenek) {
            return DropdownMenuItem<String>(
              value: yetenek,
              child: Text(yetenek, style: const TextStyle(fontSize: 16)),
            );
          }).toList(),
          onChanged: (String? yeniDeger) {
            setState(() {
              _secilenYetenek = yeniDeger;
            });
          },
        ),
      ],
    );
  }
}

class _OzellesmisTextField extends StatelessWidget {
  final String hintText;
  final int minLines;
  final int maxLines;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const _OzellesmisTextField({
    required this.hintText,
    this.minLines = 5,
    this.maxLines = 5,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.top,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
