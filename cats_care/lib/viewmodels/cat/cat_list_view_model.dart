import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../models/cat_information_model.dart';

class CatListViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Cat> cats = [];

  CatListViewModel() {
    loadCats(); // Gọi loadCats khi khởi tạo ViewModel
  }

  Future<void> loadCats() async {
    _firestore.collection('cats').snapshots().listen((snapshot) {
      cats.clear();
      for (final doc in snapshot.docs) {
        // ignore: unnecessary_cast
        cats.add(Cat.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
      notifyListeners();
    });
  }

  Future<void> deleteCat(String catId) async {
    try {
      await _firestore.collection('cats').doc(catId).delete();
      print('Đã xóa mèo có ID: $catId');
      // No changes needed here, notifyListeners() is sufficient
    } catch (e) {
      print('Lỗi khi xóa mèo: $e');
    }
    notifyListeners();
  }

  Future<void> updateCat(String catId, double? newWeight,
      DateTime? newDateOfBirth, String? newImagePath) async { // Đổi tên tham số
    try {
      Map<String, dynamic> updateData = {};
      if (newWeight != null) {
        updateData['weight'] = newWeight;
      }
      if (newDateOfBirth != null) {
        updateData['dateOfBirth'] = newDateOfBirth;
      }
      if (newImagePath != null) {
        updateData['imagePath'] = newImagePath; // Cập nhật trường
      }

      if (updateData.isNotEmpty) {
        await _firestore.collection('cats').doc(catId).update(updateData);
        print('Đã cập nhật thông tin mèo có ID: $catId');
      }
    } catch (e) {
      print('Lỗi khi cập nhật thông tin mèo: $e');
    }
    notifyListeners();
  }
}