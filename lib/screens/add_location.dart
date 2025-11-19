import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/upload_photo_screen.dart';
import 'package:zoozy/services/places_service.dart'; // Backend proxy servisini import ettik

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  // Metin giriş alanları için kontrolcüler
  final TextEditingController aramaKontrolcusu = TextEditingController();
  final TextEditingController daireKontrolcusu = TextEditingController();
  final TextEditingController caddeKontrolcusu = TextEditingController();
  final TextEditingController sehirKontrolcusu = TextEditingController();
  final TextEditingController eyaletKontrolcusu = TextEditingController();
  final TextEditingController postaKoduKontrolcusu = TextEditingController();
  final TextEditingController ulkeKontrolcusu = TextEditingController();

  final OutlineInputBorder _inputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Color(0xFFD3D3D3)),
  );

  // Backend’den gelen yerleri saklayacağız
  List _places = [];
  Timer? _debounce;

  @override
  void dispose() {
    aramaKontrolcusu.dispose();
    daireKontrolcusu.dispose();
    caddeKontrolcusu.dispose();
    sehirKontrolcusu.dispose();
    eyaletKontrolcusu.dispose();
    postaKoduKontrolcusu.dispose();
    ulkeKontrolcusu.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Input değişimlerini debounce ile backend çağrısı yap
  void _onPlaceChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isNotEmpty) {
        try {
          final results = await PlacesService.getPlaces(value);
          setState(() => _places = results);
        } catch (e) {
          print(e);
        }
      } else {
        setState(() => _places = []);
      }
    });
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Üst Çubuk
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
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
                        'Konum Ekle',
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
                const SizedBox(height: 16),

                // İçerik Alanı
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth = math.min(
                        constraints.maxWidth * 0.9,
                        900,
                      );
                      final double fontSize = constraints.maxWidth > 1000
                          ? 18
                          : (constraints.maxWidth < 360 ? 14 : 16);

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
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'İlan Konumu',
                                        style: TextStyle(
                                          fontSize: fontSize + 6,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Evcil hayvan sahipleri, sadece rezervasyon yaptıklarında tam adresinizi görebilecekler.",
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 25),

                                      // Arama input
                                      _buildInputField(
                                        ipucu: 'Aramak için yazın',
                                        kontrolcu: aramaKontrolcusu,
                                        saltOkunur: false,
                                        onChanged: _onPlaceChanged,
                                      ),

                                      // Backend’den gelen sonuçları listele
                                      if (_places.isNotEmpty)
                                        SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                            itemCount: _places.length,
                                            itemBuilder: (context, index) {
                                              final place = _places[index];
                                              return ListTile(
                                                title: Text(place[
                                                        "structured_formatting"]
                                                    ["main_text"]),
                                                subtitle: Text(
                                                    place["structured_formatting"]
                                                            [
                                                            "secondary_text"] ??
                                                        ""),
                                                onTap: () {
                                                  setState(() {
                                                    aramaKontrolcusu.text =
                                                        place["description"];
                                                    _places = [];
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),

                                      const SizedBox(height: 20),
                                      _buildInputField(
                                        ipucu: 'Daire, kat, vs.',
                                        kontrolcu: daireKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Sokak',
                                        kontrolcu: caddeKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Şehir',
                                        kontrolcu: sehirKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Eyalet / İlçe',
                                        kontrolcu: eyaletKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Posta Kodu',
                                        kontrolcu: postaKoduKontrolcusu,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        ipucu: 'Ülke',
                                        kontrolcu: ulkeKontrolcusu,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),

                              // İLERİ Butonu
                              GestureDetector(
                                onTap: () {
                                  final args = ModalRoute.of(context)
                                      ?.settings
                                      .arguments as Map<String, dynamic>?;
                                  String petName = args != null
                                      ? (args['petName'] ?? '')
                                      : '';
                                  String serviceName = args != null
                                      ? (args['serviceName'] ?? '')
                                      : '';
                                  DateTime startDate = args != null
                                      ? (args['startDate'] ?? DateTime.now())
                                      : DateTime.now();
                                  DateTime endDate = args != null
                                      ? (args['endDate'] ?? DateTime.now())
                                      : DateTime.now();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UploadPhotoScreen(),
                                      settings: RouteSettings(arguments: {
                                        'petName': petName,
                                        'serviceName': serviceName,
                                        'startDate': startDate,
                                        'endDate': endDate,
                                      }),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.purple,
                                        Colors.deepPurpleAccent,
                                      ],
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
                                      'İLERİ',
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
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String ipucu,
    TextEditingController? kontrolcu,
    bool saltOkunur = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: kontrolcu,
      readOnly: saltOkunur,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: ipucu,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        fillColor: Colors.white,
        filled: true,
        border: _inputBorder,
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFF8A2BE2), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
      ),
    );
  }
}
