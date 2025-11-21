import 'package:flutter/material.dart';

import '../data/project_pets.dart';

class PetsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _pets =
      projectPets.map((pet) => Map<String, dynamic>.from(pet)).toList();

  List<Map<String, dynamic>> get pets => List.unmodifiable(_pets);

  void addPet(Map<String, dynamic> pet) {
    _pets.add(pet);
    notifyListeners();
  }

  void removePet(int index) {
    _pets.removeAt(index);
    notifyListeners();
  }
}
