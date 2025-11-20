import 'package:flutter/material.dart';
// Lütfen bu import yolunun projenizdeki pet_breed.dart dosyası ile eşleştiğinden emin olun.
import 'package:zoozy/data/pet_breed.dart';
// Çeviri dosyası import edildi
import 'package:zoozy/data/pet_type_translations.dart';

// ----------------------------------------------------
// UI ve Stil için sabit renkler (PetWeightSelectionPage'den alındı)
// ----------------------------------------------------
const Color _gradientStartColor = Color(0xFFB39DDB);
const Color _gradientEndColor = Color(0xFFF48FB1);
const Color _activeButtonStartColor = Colors.deepPurple;
const Color _activeButtonEndColor = Colors.purpleAccent;

class PetBreedSelectionPage extends StatefulWidget {
  // petType değeri, pet_breed.dart dosyasındaki İngilizce anahtarlardan biri olmalıdır.
  final String petType;
  const PetBreedSelectionPage({super.key, required this.petType});

  @override
  State<PetBreedSelectionPage> createState() => _PetBreedSelectionPageState();
}

class _PetBreedSelectionPageState extends State<PetBreedSelectionPage> {
  String? selectedBreed;

  // Hayvan türünün İngilizce adını alıp Türkçe karşılığını döndürür.
  String getTurkishPetType() {
    // petTypeTranslations dosyası mevcut varsayılıyor
    return petTypeTranslations[widget.petType] ?? widget.petType;
  }

  // Türe özel ırk listesini çeker.
  List<String> get allBreeds {
    return petBreeds[widget.petType] ?? [];
  }

  // Yeni widget: Liste öğesi için sol taraftaki ikonu döndürür.
  Widget _LeadingWidget({required bool isSelected}) {
    if (!isSelected) {
      // Seçili değilse içi boş radyo butonu
      return Icon(Icons.radio_button_unchecked, color: Colors.grey.shade600);
    }
    // Seçiliyse onay işareti
    return const Icon(Icons.check_circle, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    final breeds = allBreeds;
    final String turkishPetType = getTurkishPetType();

    // Ekran genişliğini alıyoruz
    final double screenWidth = MediaQuery.of(context).size.width;
    // Maksimum içerik genişliği (PetWeightSelectionPage ile aynı)
    const double maxContentWidth = 550;

    return Scaffold(
      // AppBar ile arka plan gradyanının uyumu için
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          // AppBar başlığı Türkçe ve türe göre güncellendi
          "$turkishPetType Irk Seçimi",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        centerTitle: true,
      ),
      body: Container(
        // Arka Plan Gradyanı (PetWeightSelectionPage ile aynı)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStartColor, _gradientEndColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          // İçeriği ortalamak ve genişliğini kısıtlamak için Center/ConstrainedBox
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                children: [
                  // Ana içerik kutusu
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      // Yatay margin sadece ekran maxContentWidth'ten küçükken (yani mobilde) etkili
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth > maxContentWidth ? 0 : 16,
                      ),
                      padding: const EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                        color: Colors.white, // Beyaz arka plan
                        borderRadius:
                            BorderRadius.circular(25), // Yuvarlak köşeler
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              // Başlık Türkçe ve türe özel güncellendi
                              "$turkishPetType ırkını seçiniz",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          /// 🐾 Irk Liste Görünümü (Kilo seçim sayfası ile aynı stil)
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: breeds.length,
                              itemBuilder: (context, index) {
                                final breed = breeds[index];
                                final bool isSelected = selectedBreed == breed;

                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedBreed = breed),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 24),
                                    decoration: BoxDecoration(
                                      // Aktif seçili durum için gradyan
                                      gradient: isSelected
                                          ? const LinearGradient(
                                              colors: [
                                                _activeButtonStartColor,
                                                _activeButtonEndColor,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            )
                                          : null,
                                      color:
                                          !isSelected ? Colors.grey[50] : null,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        if (isSelected) // Sadece seçiliyken gölge
                                          BoxShadow(
                                            color: Colors.purpleAccent
                                                .withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        leading: _LeadingWidget(
                                            isSelected: isSelected),
                                        title: Text(
                                          breed,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        trailing: isSelected
                                            ? const Icon(Icons.chevron_right,
                                                color: Colors.white)
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// 🔘 Devam Et Butonu (Kilo seçim sayfası ile aynı stil)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            child: GestureDetector(
                              onTap: selectedBreed != null
                                  ? () => Navigator.pop(context, selectedBreed)
                                  : null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: selectedBreed != null
                                        ? const [
                                            _activeButtonStartColor,
                                            _activeButtonEndColor,
                                          ]
                                        : [
                                            Colors.grey.shade400,
                                            Colors.grey.shade300
                                          ], // Pasif buton rengi
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    "Devam Et",
                                    style: TextStyle(
                                      color: selectedBreed != null
                                          ? Colors.white
                                          : Colors
                                              .black54, // Pasif buton metin rengi
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // --- BUTON BİTİŞİ ---
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
