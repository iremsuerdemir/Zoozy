import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pet_breed_selection_page.dart';
import 'pet_type_selection_page.dart';
import 'pet_weight_selection_page.dart';
import 'service_date_page.dart';

class PetProfilePage extends StatefulWidget {
  final bool fromRequestPage;
  final String? serviceName;

  const PetProfilePage({
    Key? key,
    this.fromRequestPage = false,
    this.serviceName,
  }) : super(key: key);

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  List<Map<String, dynamic>> pets = [];
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  // ✅ Senaryon: 1 ve daha fazlası aktif - 0 pasif
  bool get isNextButtonActive => selectedIndexes.isNotEmpty;

  //---------------- STORAGE ----------------//

  Future<void> _loadPets() async {
    final prefs = await SharedPreferences.getInstance();

    final petsRaw = prefs.getString("pets");
    final selectedRaw = prefs.getString("selectedIndexes_profile");

    if (petsRaw != null) {
      final List decoded = jsonDecode(petsRaw);
      pets = decoded.map<Map<String, dynamic>>((p) {
        final type = p["type"];
        return {
          "type": type,
          "breed": p["breed"],
          "weight": p["weight"],
          "color": getPetColor(type),
          "icon": getPetIcon(type),
        };
      }).toList();
    }

    if (selectedRaw != null && !widget.fromRequestPage) {
      final List decoded = jsonDecode(selectedRaw);
      selectedIndexes = decoded.map<int>((e) => e as int).toSet();
    }

    setState(() {});
  }

  Future<void> _savePets() async {
    final prefs = await SharedPreferences.getInstance();

    final petListJson = pets.map((p) {
      return {
        "type": p["type"],
        "breed": p["breed"],
        "weight": p["weight"],
      };
    }).toList();

    prefs.setString("pets", jsonEncode(petListJson));
    prefs.setString(
      "selectedIndexes_profile",
      jsonEncode(selectedIndexes.toList()),
    );
  }

  //---------------- COLOR / ICON ----------------//

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
    return Icons.pets;
  }

  void _handleSelect(int index) {
    setState(() {
      selectedIndexes.contains(index)
          ? selectedIndexes.remove(index)
          : selectedIndexes.add(index);
    });

    _savePets();
  }

  //---------------- DELETE PET ----------------//

  void _deletePet(int index) {
    setState(() {
      pets.removeAt(index);
      selectedIndexes.remove(index);

      // index kaymasını düzelt
      selectedIndexes =
          selectedIndexes.map((i) => i > index ? i - 1 : i).toSet();
    });

    _savePets();
  }

  //---------------- EDIT PET ----------------//

  Future<void> _editPet(int index) async {
    final type = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PetTypeSelectionPage(),
      ),
    );

    if (type != null) {
      final breed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PetBreedSelectionPage(petType: type),
        ),
      );

      if (breed != null) {
        final weight = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PetWeightSelectionPage(
              petType: type,
              breed: breed,
            ),
          ),
        );

        if (weight != null) {
          setState(() {
            pets[index] = {
              "type": type,
              "breed": breed,
              "weight": weight,
              "color": getPetColor(type),
              "icon": getPetIcon(type),
            };
          });

          await _savePets();
        }
      }
    }
  }

  //---------------- UI ----------------//

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _savePets();
        return true;
      },
      child: Scaffold(
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
                  //---------------- APP BAR ----------------//
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () async {
                            await _savePets();
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          "Hayvanlarım",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.fromRequestPage
                            ? IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                onPressed: _showInfoDialog,
                              )
                            : const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

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
                          children: [
                            const Text(
                              "Kayıtlı Evcil Hayvanların",
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // ✅ SADECE REQUEST PAGE’TE GÖRÜNÜR
                            if (widget.fromRequestPage)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const PetProfilePage(
                                            fromRequestPage: false),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Yeni hayvan eklemek / düzenlemek için\nHayvanlarım sayfasına gitmek için tıklayın",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 10),

                            //---------------- PET LIST ----------------//
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.fromRequestPage
                                    ? pets.length
                                    : pets.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < pets.length) {
                                    final pet = pets[index];
                                    final isSelected =
                                        selectedIndexes.contains(index);

                                    return GestureDetector(
                                      onTap: () => _handleSelect(index),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: isSelected
                                              ? Border.all(
                                                  color: Colors.deepPurple,
                                                  width: 2)
                                              : null,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 6,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: pet['color'],
                                              child: Icon(
                                                pet['icon'],
                                                color: Colors.white,
                                                size: 26,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text("Irk: ${pet['breed']}"),
                                                  Text(
                                                      "Ağırlık: ${pet['weight']}"),
                                                ],
                                              ),
                                            ),

                                            // REQUEST PAGE = SELECT
                                            // PROFILE PAGE = EDIT + DELETE
                                            widget.fromRequestPage
                                                ? Icon(
                                                    isSelected
                                                        ? Icons.check_circle
                                                        : Icons.circle_outlined,
                                                    color: isSelected
                                                        ? Colors.deepPurple
                                                        : Colors.grey,
                                                  )
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                        onPressed: () =>
                                                            _editPet(index),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () =>
                                                            _deletePet(index),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // ADD NEW PET
                                  return GestureDetector(
                                    onTap: () async {
                                      final type = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const PetTypeSelectionPage(),
                                        ),
                                      );

                                      if (type != null) {
                                        final breed = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                PetBreedSelectionPage(
                                              petType: type,
                                            ),
                                          ),
                                        );

                                        if (breed != null) {
                                          final weight = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PetWeightSelectionPage(
                                                petType: type,
                                                breed: breed,
                                              ),
                                            ),
                                          );

                                          if (weight != null) {
                                            setState(() {
                                              pets.insert(0, {
                                                "type": type,
                                                "breed": breed,
                                                "weight": weight,
                                                "color": getPetColor(type),
                                                "icon": getPetIcon(type),
                                              });
                                            });

                                            await _savePets();
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                            color: Colors.deepPurple),
                                        color: Colors.grey.shade50,
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.add,
                                              color: Colors.deepPurple),
                                          SizedBox(width: 12),
                                          Text(
                                            "Yeni Evcil Hayvan Ekle",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurple),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // NEXT BUTTON (Request Page only)
                            if (widget.fromRequestPage)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: GestureDetector(
                                  onTap: isNextButtonActive
                                      ? () {
                                          final selectedPet =
                                              pets[selectedIndexes.first];

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ServiceDatePage(
                                                petName: selectedPet['type'],
                                                serviceName:
                                                    widget.serviceName ??
                                                        "Pansiyon",
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: BoxDecoration(
                                      color: isNextButtonActive
                                          ? Colors.deepPurple
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(14),
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
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //------------------ INFO DIALOG ------------------//

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Bilgi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Yeni hayvan eklemek veya düzenlemek için Hayvanlarım sayfasına gitmelisiniz.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PetProfilePage(fromRequestPage: false),
                  ),
                ).then((_) {
                  _loadPets();
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.purple],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Hayvanlarım Sayfasına Git",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Vazgeç",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
