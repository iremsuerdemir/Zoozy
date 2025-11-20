import 'package:flutter/material.dart';

import 'pet_breed_selection_page.dart';
import 'pet_type_selection_page.dart';
import 'pet_weight_selection_page.dart';

class PetWalkPage extends StatefulWidget {
  const PetWalkPage({Key? key}) : super(key: key);

  @override
  State<PetWalkPage> createState() => _PetWalkPageState();
}

class _PetWalkPageState extends State<PetWalkPage> {
  List<Map<String, dynamic>> pets = [];
  Set<int> selectedIndexes = {};

  // Renk ve ikon ataması (isteğe göre geliştirilebilir)
  Color getPetColor(String type) {
    switch (type) {
      case 'Köpek':
        return Colors.orange;
      case 'Kedi':
        return Colors.redAccent;
      case 'Kuş':
        return Colors.lightBlue;
      case 'Tavşan':
        return Colors.green;
      case 'Balık':
        return Colors.cyan;
      default:
        return Colors.purpleAccent;
    }
  }

  IconData getPetIcon(String type) {
    switch (type) {
      case 'Köpek':
        return Icons.pets;
      case 'Kedi':
        return Icons.pets;
      case 'Kuş':
        return Icons.flight;
      case 'Tavşan':
        return Icons.pets;
      case 'Balık':
        return Icons.pool;
      default:
        return Icons.pets;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan gradient
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
                // Üst bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Yürüyüşe Başla",
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

                const SizedBox(height: 16),

                // Ana içerik
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Yürüyüşe hangi evcil hayvanlar katılacak?",
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Evcil hayvan yürütücüsü kiralama
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Evcil hayvan yürütücüsü kiralandı!",
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    child: Icon(
                                      Icons.directions_walk,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Evcil Hayvan Yürüyüş Arkadaşı Kirala",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Yürüyüş Arkadaşı kiralamak için buraya dokun",
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),

                          // Evcil hayvan kartları
                          Expanded(
                            child: ListView.builder(
                              itemCount: pets.length + 1,
                              itemBuilder: (context, index) {
                                if (index < pets.length) {
                                  final pet = pets[index];
                                  final isSelected =
                                      selectedIndexes.contains(index);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSelected
                                            ? selectedIndexes.remove(index)
                                            : selectedIndexes.add(index);
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: pet['color'],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              pet["icon"],
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  pet['type'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text("Tür: ${pet['breed']}"),
                                                Text(
                                                  "Ağırlık: ${pet['weight']}",
                                                ),
                                              ],
                                            ),
                                          ),
                                          Checkbox(
                                            value: isSelected,
                                            onChanged: (_) {
                                              setState(() {
                                                isSelected
                                                    ? selectedIndexes.remove(
                                                        index,
                                                      )
                                                    : selectedIndexes.add(
                                                        index,
                                                      );
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () async {
                                      final type = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const PetTypeSelectionPage()),
                                      );
                                      if (type != null) {
                                        final breed = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  PetBreedSelectionPage(
                                                      petType: type)),
                                        );
                                        if (breed != null) {
                                          final weight = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    PetWeightSelectionPage(
                                                        petType: type,
                                                        breed: breed)),
                                          );
                                          if (weight != null) {
                                            setState(() {
                                              pets.add({
                                                "type": type,
                                                "breed": breed,
                                                "weight": weight,
                                                "color": getPetColor(type),
                                                "icon": getPetIcon(type),
                                              });
                                            });
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      margin: const EdgeInsets.only(top: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade100,
                                        border: Border.all(
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.deepPurple,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "Başka Evcil Hayvan Ekle",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Yürüyüşü başlat butonu
                          GestureDetector(
                            onTap: selectedIndexes.isNotEmpty
                                ? () {
                                    final selectedPetsText = selectedIndexes
                                        .map((i) => pets[i]['type'])
                                        .join(', ');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Seçilen evcil hayvanlar: $selectedPetsText"),
                                      ),
                                    );
                                  }
                                : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: selectedIndexes.isNotEmpty
                                      ? [Colors.deepPurple, Colors.purpleAccent]
                                      : [
                                          Colors.grey.shade400,
                                          Colors.grey.shade300,
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  "Yürüyüşü Başlat",
                                  style: TextStyle(
                                    color: selectedIndexes.isNotEmpty
                                        ? Colors.white
                                        : Colors.black54,
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
