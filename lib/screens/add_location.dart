import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController aptController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final OutlineInputBorder _inputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Color(0xFFD3D3D3)),
  );
  static const String googleApiKey = "AIzaSyCxCjJKz8p4hDgYuzpSs27mCRGAmc8BFI4";

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

                                      // Google Places Autocomplete (show ile)
                                      _buildInputField(
                                        hint: 'Aramak için yazın',
                                        controller: searchController,
                                        readOnly: false,
                                        onTap: () async {
                                          final p =
                                              await PlacesAutocomplete.show(
                                                context: context,
                                                apiKey: googleApiKey,
                                                mode: Mode.overlay,
                                                types: [],
                                                strictbounds: false,
                                                onError: (err) => print(err),
                                              );

                                          if (p != null) {
                                            setState(() {
                                              searchController.text =
                                                  p.description ?? '';
                                            });
                                          }
                                        },
                                      ),

                                      const SizedBox(height: 20),
                                      _buildInputField(
                                        hint: 'Daire, kat, vs.',
                                        controller: aptController,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        hint: 'Sokak',
                                        controller: streetController,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        hint: 'Şehir',
                                        controller: cityController,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        hint: 'Eyalet',
                                        controller: stateController,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        hint: 'Posta Kodu',
                                        controller: postalController,
                                      ),
                                      const SizedBox(height: 15),
                                      _buildInputField(
                                        hint: 'Ülke',
                                        controller: countryController,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (searchController.text.isEmpty ||
                                      aptController.text.isEmpty ||
                                      streetController.text.isEmpty ||
                                      cityController.text.isEmpty ||
                                      stateController.text.isEmpty ||
                                      postalController.text.isEmpty ||
                                      countryController.text.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                        content: const Text(
                                          'Please provide a more accurate address of your service to proceed.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: TextButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF9370DB,
                                              ),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
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
    required String hint,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
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
