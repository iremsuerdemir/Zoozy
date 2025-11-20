import 'package:flutter/material.dart';

class PetTypeSelectionPage extends StatelessWidget {
  const PetTypeSelectionPage({super.key});

  static const List<Map<String, String>> petTypes = [
    {"name": "Köpek", "image": "assets/images/icons/dog.png"},
    {"name": "Kedi", "image": "assets/images/icons/cat.png"},
    {"name": "Tavşan", "image": "assets/images/icons/rabbit.png"},
    {"name": "Balık", "image": "assets/images/icons/fish.png"},
    {"name": "Kuş", "image": "assets/images/icons/parrot.png"},
    {"name": "Diğer", "image": "assets/images/icons/others.png"},
  ];

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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              // sabit bir appbar ikonu göstermek istersen burayı kullan:
              Image(
                image: AssetImage("assets/images/icons/dog.png"),
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8),
              Text(
                "Hayvan Türü Seç",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: const [SizedBox(width: 48)],
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
            final imagePath = pet["image"] ?? "";

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
                            // Eğer asset yüklenemezse proje içindeki fallback görselini göster
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Image.asset(
                                  'assets/images/icons/others.png', // fallback asset
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
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
