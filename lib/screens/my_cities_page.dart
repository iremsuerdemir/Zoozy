import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoozy/screens/board_note_page.dart';
import 'package:zoozy/screens/upload_photo_screen.dart';
import 'package:zoozy/services/places_service.dart';

class MyCitiesPage extends StatefulWidget {
  const MyCitiesPage({super.key});

  @override
  State<MyCitiesPage> createState() => _MyCitiesPageState();
}

class _MyCitiesPageState extends State<MyCitiesPage> {
  final TextEditingController aramaKontrolcusu = TextEditingController();
  final TextEditingController caddeKontrolcusu = TextEditingController();
  final TextEditingController sehirKontrolcusu = TextEditingController();
  final TextEditingController ulkeKontrolcusu = TextEditingController();

  // Eksik controller'lar TAMAMLANDI

  final TextEditingController eyaletKontrolcusu = TextEditingController();

  final OutlineInputBorder _inputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Color(0xFFD3D3D3)),
  );

  List _places = [];
  Timer? _debounce;

  @override
  void dispose() {
    aramaKontrolcusu.dispose();
    caddeKontrolcusu.dispose();
    sehirKontrolcusu.dispose();
    ulkeKontrolcusu.dispose();
    eyaletKontrolcusu.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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
                // ⭐ ÜST BAR METNİ "Konum Seç" OLARAK GÜNCELLENDİ
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "Konum Seç",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
                      final double maxWidth =
                          math.min(constraints.maxWidth * 0.9, 900);
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
                                      // ⭐ EK METİN "Hizmeti nereye istiyorsunuz?"
                                      Text(
                                        "Hizmeti nereden istiyorsunuz?",
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.grey[700],
                                        ),
                                      ),

                                      const SizedBox(height: 25),

                                      // ⭐ ARAMA HINT → "Konum ara..."
                                      _buildInputField(
                                        ipucu: "Konum ara...",
                                        kontrolcu: aramaKontrolcusu,
                                        onChanged: _onPlaceChanged,
                                      ),

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
                                                          ["secondary_text"] ??
                                                      "",
                                                ),
                                                onTap: () async {
                                                  final placeId =
                                                      place['place_id'];
                                                  final details =
                                                      await PlacesService
                                                          .getPlaceDetails(
                                                              placeId);

                                                  final components = details[
                                                              'result']
                                                          ['address_components']
                                                      as List;

                                                  String sokakNumarasi = '';
                                                  String cadde = '';
                                                  String il = '';
                                                  String ilce = '';
                                                  String postaKodu = '';
                                                  String ulke = '';

                                                  for (var c in components) {
                                                    final types =
                                                        c['types'] as List;

                                                    if (types.contains(
                                                        'street_number')) {
                                                      sokakNumarasi =
                                                          c['long_name'];
                                                    }

                                                    if (types
                                                        .contains('route')) {
                                                      cadde = c['long_name'];
                                                    }

                                                    if (types.contains(
                                                        'administrative_area_level_1')) {
                                                      il = c['long_name'];
                                                    }

                                                    if (types.contains(
                                                        'administrative_area_level_2')) {
                                                      ilce = c['long_name'];
                                                    }

                                                    if (types.contains(
                                                        'postal_code')) {
                                                      postaKodu =
                                                          c['long_name'];
                                                    }

                                                    if (types
                                                        .contains('country')) {
                                                      ulke = c['long_name'];
                                                    }
                                                  }

                                                  String tamCadde = [
                                                    sokakNumarasi,
                                                    cadde
                                                  ]
                                                      .where(
                                                          (s) => s.isNotEmpty)
                                                      .join(' ');

                                                  setState(() {
                                                    aramaKontrolcusu.text =
                                                        place['description'];

                                                    caddeKontrolcusu.text =
                                                        tamCadde;
                                                    sehirKontrolcusu.text = il;
                                                    eyaletKontrolcusu.text =
                                                        ilce;

                                                    ulkeKontrolcusu.text = ulke;
                                                    _places = [];
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),

                                      const SizedBox(height: 20),

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
                                        ipucu: 'İlçe',
                                        kontrolcu: eyaletKontrolcusu,
                                      ),

                                      const SizedBox(height: 15),

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

                              // ⭐ BUTON METNİ "İleri" YAPILDI
                              GestureDetector(
                                onTap: () {
                                  final args = ModalRoute.of(context)
                                      ?.settings
                                      .arguments as Map<String, dynamic>?;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BoardNotePage(),
                                      settings:
                                          RouteSettings(arguments: args ?? {}),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                                      "İleri",
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
