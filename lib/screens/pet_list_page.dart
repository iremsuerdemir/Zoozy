import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pets_provider.dart';
import 'pet_breed_selection_page.dart';
import 'pet_type_selection_page.dart';
import 'pet_weight_selection_page.dart';
import 'profile_screen.dart';

class PetListPage extends StatelessWidget {
  const PetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final petsProvider = Provider.of<PetsProvider>(context);
    final pets = petsProvider.pets;

    String resolvePetImage(Map<String, dynamic> pet) {
      final image = pet['image'];
      if (image is String && image.isNotEmpty) return image;

      switch (pet['type']) {
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

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB39DDB),
                  Color(0xFFF48FB1),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // App bar style
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      _BackToProfileButton(),
                      const SizedBox(width: 12),
                      const Text(
                        "Evcil Hayvanlarım",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: pets.isEmpty
                      ? const Center(
                          child: Text(
                            "Henüz evcil hayvan eklemedin.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: pets.length,
                          itemBuilder: (context, index) {
                            final pet = pets[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: ClipOval(
                                  child: Image.asset(
                                    resolvePetImage(pet),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.pets,
                                      size: 40,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  pet['type'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Irk: ${pet['breed'] ?? 'Bilgi yok'}",
                                    ),
                                    Text(
                                      "Ağırlık: ${pet['weight'] ?? 'Belirtilmedi'}",
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    petsProvider.removePet(index);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () async {
          final type = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (_) => const PetTypeSelectionPage()),
          );
          if (type == null) return;

          final breed = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (_) => PetBreedSelectionPage(petType: type),
            ),
          );
          if (breed == null) return;

          final weight = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (_) => PetWeightSelectionPage(
                petType: type,
                breed: breed,
              ),
            ),
          );
          if (weight == null) return;

          petsProvider.addPet({
            'type': type,
            'breed': breed,
            'weight': weight,
            'image': resolvePetImage({'type': type}),
          });

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$type başarıyla eklendi!')),
            );
          }
        },
      ),
    );
  }
}

class _BackToProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
