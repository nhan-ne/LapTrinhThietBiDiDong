// lib/models/cat_hotel_model.dart
class CatHotel {
  final String name;
  final String address;
  final String phone;
  final String services;
  final String image;

  CatHotel({
    required this.name,
    required this.address,
    required this.phone,
    required this.services,
    required this.image,
  });

  factory CatHotel.fromJson(Map<String, dynamic> json) {
    return CatHotel(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      services: json['services'],
      image: json['image'],
    );
  }
}