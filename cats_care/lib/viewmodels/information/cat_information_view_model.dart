import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/models/cat_information_model.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
// ignore: unused_import
import 'package:path/path.dart' as path;

class AddCatViewModel extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  DateTime? selectedDate;
  String? selectedGender;
  XFile? pickedImage;
  String? imagePath; // Lưu đường dẫn cục bộ của ảnh
  File? _oldImageFile; // Thêm biến này để lưu trữ ảnh cũ

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
      notifyListeners();
    }
  }

  void selectGender(String? gender) {
    selectedGender = gender;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Xóa ảnh cũ nếu có
      if (_oldImageFile != null && _oldImageFile!.existsSync()) {
        _oldImageFile!.deleteSync();
      }
      pickedImage = image;
      _oldImageFile = File(image.path); // Lưu trữ ảnh mới để xóa sau này
      notifyListeners();
    }
  }

  // Hàm lưu ảnh vào thư mục ứng dụng
  Future<String?> _saveImageToDocuments(XFile? pickedFile) async {
    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'cat_image_${DateTime.now().millisecondsSinceEpoch}.png';
    final savedImage = await file.copy('${appDir.path}/$fileName');
    return savedImage.path;
  }

  Future<void> saveCat() async {
    if (pickedImage == null) {
      print('Không thể lưu thông tin mèo do không có ảnh.');
      return;
    }

    imagePath = await _saveImageToDocuments(pickedImage);

    if (imagePath != null) {
      Cat newCat = Cat(
        name: nameController.text,
        breed: breedController.text,
        dateOfBirth: selectedDate,
        gender: selectedGender,
        weight: double.tryParse(weightController.text),
        imagePath: imagePath,
      );

      try {
        await _firestore.collection('cats').add(newCat.toMap());
        print('Thông tin mèo đã được lưu thành công!');
      } catch (e) {
        print('Lỗi khi lưu thông tin mèo: $e');
      }
    }
  }

  void clearData() {
    nameController.clear();
    breedController.clear();
    weightController.clear();
    selectedDate = null;
    selectedGender = null;
    pickedImage = null;
    imagePath = null;
    notifyListeners();
  }
}