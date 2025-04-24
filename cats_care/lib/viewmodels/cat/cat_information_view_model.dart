import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/models/cat_information.dart'; // Import model Cat

class AddCatViewModel extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  DateTime? selectedDate;
  String? selectedGender;
  XFile? pickedImage;
  String? imageUrl; // URL của ảnh sau khi tải lên

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners(); // Báo cho View biết trạng thái đã thay đổi
    }
  }

  void selectGender(String? gender) {
    selectedGender = gender;
    notifyListeners();
  }

  Future<void> pickImage() async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      notifyListeners();
    }
  }

  Future<void> uploadImage() async {
    if (pickedImage == null) return;
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = _storage.ref().child('cats/$fileName');
      await ref.putFile(File(pickedImage!.path));
      imageUrl = await ref.getDownloadURL();
      notifyListeners();
    } catch (e) {
      print('Lỗi tải ảnh lên: $e');
      // Xử lý lỗi tại đây (ví dụ: hiển thị thông báo cho người dùng)
    }
  }

  Future<void> saveCat() async {
    await uploadImage(); // Tải ảnh lên trước khi lưu thông tin

    Cat newCat = Cat(
      name: nameController.text,
      breed: breedController.text,
      dateOfBirth: selectedDate,
      gender: selectedGender,
      weight: double.tryParse(weightController.text),
      imageUrl: imageUrl,
    );

    try {
      await _firestore.collection('cats').add(newCat.toMap());
      // Sau khi lưu thành công, bạn có thể thực hiện các hành động khác,
      // ví dụ: hiển thị thông báo thành công, chuyển về màn hình danh sách mèo, v.v.
      print('Thông tin mèo đã được lưu thành công!');
    } catch (e) {
      print('Lỗi khi lưu thông tin mèo: $e');
      // Xử lý lỗi tại đây
    }
  }
}