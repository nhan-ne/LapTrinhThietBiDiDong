import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../models/veterinary_model.dart';

class VeterinaryViewModel extends ChangeNotifier {
  List<Veterinary> _originalVeterinaryData = [];
  List<Veterinary> _filteredVeterinaryData = [];
  TextEditingController searchController = TextEditingController();

  List<Veterinary> get filteredVeterinaryData => _filteredVeterinaryData;

  VeterinaryViewModel() {
    loadVeterinaryData();
    searchController.addListener(onSearchChanged);
  }

  Future<void> loadVeterinaryData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/veterinaries.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _originalVeterinaryData = jsonList.map((json) => Veterinary.fromJson(json)).toList();
      _filteredVeterinaryData = List.from(_originalVeterinaryData); // Initialize filtered data with all data
      notifyListeners();
    } catch (e) {
      print('Error loading veterinary data: $e');
    }
  }

  void onSearchChanged() {
    final String searchText = searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      _filteredVeterinaryData = List.from(_originalVeterinaryData);
    } else {
      _filteredVeterinaryData = _originalVeterinaryData
          .where((vet) =>
          vet.name.toLowerCase().contains(searchText))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}