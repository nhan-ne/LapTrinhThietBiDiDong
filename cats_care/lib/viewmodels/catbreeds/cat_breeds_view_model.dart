import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CatBreedsViewModel extends ChangeNotifier {
  List<dynamic> _catBreeds = [];
  List<dynamic> _filteredCatBreeds = [];

  List<dynamic> get catBreeds => _catBreeds;
  List<dynamic> get filteredCatBreeds => _filteredCatBreeds;

  CatBreedsViewModel() {
    loadCatBreeds();
  }

  Future<void> loadCatBreeds() async {
    try {
      String jsonString = await rootBundle.loadString('assets/catbreeds.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _catBreeds = jsonList;
      _filteredCatBreeds = _catBreeds;
      notifyListeners();
    } catch (e) {
      print('Error loading catbreeds: $e');
      // Xử lý lỗi (ví dụ: hiển thị thông báo)
    }
  }

  void filterCatBreeds(String query) {
    final normalizedQuery = removeDiacritics(query.toLowerCase());
    if (query.isEmpty) {
      _filteredCatBreeds = _catBreeds;
    } else {
      _filteredCatBreeds = _catBreeds
          .where((breed) => removeDiacritics((breed['name'] as String).toLowerCase())
          .contains(normalizedQuery))
          .toList();
    }
    notifyListeners();
  }
}