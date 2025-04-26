class UserAddress {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String note;
  final String addressType;
  bool isDefault;

  UserAddress({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.note,
    required this.addressType,
    this.isDefault = false,
  });

  // Chuyển đổi từ Map (Firestore) sang đối tượng
  factory UserAddress.fromMap(String id, Map<String, dynamic> map) {
    return UserAddress(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      note: map['note'] ?? '',
      addressType: map['addressType'] ?? '',
      isDefault: map['isDefault'] ?? false,

    );
  }

  // Chuyển đổi từ đối tượng sang Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'note': note,
      'addressType': addressType,
      'timestamp': DateTime.now(),
    };
  }
}