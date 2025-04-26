import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../../models/product_model.dart';

class ProductViewModel extends ChangeNotifier {
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  Future<void> loadProducts() async {
    try {
      String jsonString = await rootBundle.loadString('assets/products.json');
      List<dynamic> jsonList = json.decode(jsonString);
      
      _products = jsonList.map((item) => ProductModel.fromJson(item)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading products: $e');
    }
  }
  void searchProducts(String query) {
    if (query.isEmpty) {
      loadProducts();
    } else {
      _products = _products.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
    notifyListeners();
  }
  
}
