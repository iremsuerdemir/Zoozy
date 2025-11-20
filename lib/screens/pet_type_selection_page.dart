import 'package:flutter/material.dart';

class PetTypeSelectionPage extends StatelessWidget {
  const PetTypeSelectionPage({super.key});

  static const List<Map<String, String>> petTypes = [
    {"name": "Köpek", "image": "assets/my_pets_image/dog.png"},
    {"name": "Kedi", "image": "assets/my_pets_image/cat.png"},
    {"name": "Tavşan", "image": "assets/my_pets_image/rabbit.png"},
    {"name": "Balık", "image": "assets/my_pets_image/fish.png"},
    {"name": "Kuş", "image": "assets/my_pets_image/parrot.png"},
    {"name": "Diğer", "image": "assets/my_pets_image/others.png"},
  ];

  // Türlere göre fallback asset
  String getFallbackImage(String type) {
    switch (type) {
      case 'Köpek':
        return 'assets/my_pets_image/dog.png';
      case 'Kedi':
        return 'assets/my_pets_image/cat.png';
      case 'Kuş':
        return 'assets/my_pets_image/parrot.png';
      case 'Tavşan':
        return 'assets/my_pets_image/rabbit.png';
      case 'Balık':
        return 'assets/my_pets_image/fish.png';
      default:
        return 'assets/my_pets_image/others.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB388FF), Color(0xFFFF8A80)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            "Hayvan Türü Seç",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: petTypes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final pet = petTypes[index];
            final imagePath = pet["image"] ?? getFallbackImage(pet["name"]!);

            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.pop(context, pet["name"]),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFCE93D8), Color(0xFFFF80AB)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Asset yüklenemezse fallback göster
                              return Image.asset(
                                'assets/my_pets_image/others.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          pet["name"] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
    );
  }
}
