import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/models/cat_information.dart';

class CatListViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  List<Cat> cats = [];

  CatListViewModel() {
    _listenToCats();
  }

  void _listenToCats() {
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

  Future<String?> uploadImage(XFile pickedFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref =
      _storage.ref().child('cats/$fileName');
      await ref.putFile(File(pickedFile.path));
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Lỗi tải ảnh lên: $e');
      return null;
    }
  }

  Future<void> updateCat(String catId, double? newWeight,
      DateTime? newDateOfBirth, String? newImageUrl) async {
    try {
      Map<String, dynamic> updateData = {};
      if (newWeight != null) {
        updateData['weight'] = newWeight;
      }
      if (newDateOfBirth != null) {
        updateData['dateOfBirth'] = newDateOfBirth;
      }
      if (newImageUrl != null) {
        updateData['imageUrl'] = newImageUrl;
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