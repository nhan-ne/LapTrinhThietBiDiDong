import 'package:cloud_firestore/cloud_firestore.dart';

class Cat {
  String? id;
  String? name;
  String? breed;
  DateTime? dateOfBirth;
  String? gender;
  double? weight;
  String? imagePath; // Thuộc tính mới để lưu đường dẫn ảnh

  Cat({
    this.id,
    this.name,
    this.breed,
    this.dateOfBirth,
    this.gender,
    this.weight,
    this.imagePath, // Cập nhật constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'weight': weight,
      'imagePath': imagePath, // Cập nhật toMap
    };
  }

  factory Cat.fromMap(Map<String, dynamic> map, String documentId) {
    return Cat(
      id: documentId,
      name: map['name'],
      breed: map['breed'],
      dateOfBirth: map['dateOfBirth'] != null ? (map['dateOfBirth'] as Timestamp).toDate() : null,
      gender: map['gender'],
      weight: map['weight'] != null ? map['weight'].toDouble() : null,
      imagePath: map['imagePath'], // Cập nhật fromMap
    );
  }
}