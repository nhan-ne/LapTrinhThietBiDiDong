class Veterinary {
  final String name;
  final String address;
  final String phone;
  final String hours;
  final String image;

  Veterinary({
    required this.name,
    required this.address,
    required this.phone,
    required this.hours,
    required this.image,
  });

  factory Veterinary.fromJson(Map<String, dynamic> json) {
    return Veterinary(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      hours: json['hours'],
      image: json['image'],
    );
  }
}