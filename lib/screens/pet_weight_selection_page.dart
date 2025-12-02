import 'package:flutter/material.dart';

// ----------------------------------------------------
// UI ve Stil için sabit renkler
// ----------------------------------------------------
const Color _gradientStartColor = Color(0xFFB39DDB);
const Color _gradientEndColor = Color(0xFFF48FB1);
const Color _activeButtonStartColor = Colors.deepPurple;
const Color _activeButtonEndColor = Colors.purpleAccent;

class PetWeightSelectionPage extends StatefulWidget {
  final String petType;
  final String breed;

  const PetWeightSelectionPage(
      {super.key, required this.petType, required this.breed});

  @override
  State<PetWeightSelectionPage> createState() => _PetWeightSelectionPageState();
}

class _PetWeightSelectionPageState extends State<PetWeightSelectionPage> {
  String? selectedWeight;

  final List<String> weights = [
    "1-5 kg",
    "5-10 kg",
    "10-20 kg",
    "20-40 kg",
    "40+ kg",
  ];

  /// 🐾 Hayvan türüne göre ikon seçici
  IconData getPetIcon() {
    final lower = widget.petType.toLowerCase();

    if (lower.contains("kedi") || lower.contains("cat")) {
      return Icons.pets;
    } else if (lower.contains("köpek") || lower.contains("dog")) {
      return Icons.pets;
    } else if (lower.contains("kuş") || lower.contains("bird")) {
      return Icons.flutter_dash;
    } else if (lower.contains("balık") || lower.contains("fish")) {
      return Icons.set_meal;
    } else if (lower.contains("diğer") || lower.contains("others")) {
      return Icons.set_meal;
    } else if (lower.contains("tavşan") ||
        lower.contains("hamster") ||
        lower.contains("fare") ||
        lower.contains("mouse")) {
      return Icons.pets_outlined;
    }
    return Icons.pets;
  }

  // Yeni widget: Liste öğesi için sol taraftaki ikonu döndürür.
  Widget _LeadingWidget({required bool isSelected}) {
    if (!isSelected) {
      // Seçili değilse içi boş radyo butonu
      return Icon(Icons.radio_button_unchecked, color: Colors.grey.shade600);
    }
    // Seçiliyse ikon veya onay işareti
    return const Icon(Icons.check_circle, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğini alıyoruz
    final double screenWidth = MediaQuery.of(context).size.width;
    // Maksimum içerik genişliği (Örn: tablet ve web için 500-600px yeterlidir)
    const double maxContentWidth = 550;

    // final IconData petIcon = getPetIcon(); // Şu an kullanılmıyor, kaldırılabilir

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
          // AppBar başlığı
          "${widget.breed} Kilo Seçimi",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        centerTitle: true,
      ),
      body: Container(
        // Arka Plan Gradyanı (PetBreedSelectionPage ile aynı)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStartColor, _gradientEndColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          /// 💡 Yeni Yapı: İçeriği ortalamak ve genişliğini kısıtlamak için Center/ConstrainedBox kullanıldı.
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                children: [
                  // Ana içerik kutusu
                  Expanded(
                    child: Container(
                      width: double.infinity, // ConstrainedBox'a uyacak
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
                              // Başlık
                              "${widget.breed} için kilo aralığı",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          /// 🐾 Ağırlık Liste Görünümü
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: weights.length,
                              itemBuilder: (context, index) {
                                final item = weights[index];
                                final bool isSelected = selectedWeight == item;

                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedWeight = item),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 24), // Yatay padding 24
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
                                                .withOpacity(
                                                    0.3), // Daha hafif gölge
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              8), // Dikey padding azaltıldı
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal:
                                                    10), // İç padding ayarlandı
                                        leading: _LeadingWidget(
                                            isSelected: isSelected),
                                        title: Text(
                                          item,
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

                          /// 🔘 Devam Et Butonu
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            child: GestureDetector(
                              onTap: selectedWeight != null
                                  ? () => Navigator.pop(context, selectedWeight)
                                  : null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: selectedWeight != null
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
                                      color: selectedWeight != null
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
