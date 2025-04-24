import 'package:cloud_firestore/cloud_firestore.dart';

class Cat {
  String? id; // Add this line
  String? name;
  String? breed;
  DateTime? dateOfBirth;
  String? gender;
  double? weight;
  String? imageUrl;

  Cat({
    this.id, // And this one
    this.name,
    this.breed,
    this.dateOfBirth,
    this.gender,
    this.weight,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'weight': weight,
      'imageUrl': imageUrl,
    };
  }

  factory Cat.fromMap(Map<String, dynamic> map, String documentId) { // Modify this line
    return Cat(
      id: documentId, // And this one
      name: map['name'],
      breed: map['breed'],
      dateOfBirth: map['dateOfBirth'] != null ? (map['dateOfBirth'] as Timestamp).toDate() : null,
      gender: map['gender'],
      weight: map['weight'] != null ? map['weight'].toDouble() : null,
      imageUrl: map['imageUrl'],
    );
  }
}