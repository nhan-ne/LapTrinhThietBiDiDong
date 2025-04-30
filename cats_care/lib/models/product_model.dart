import 'package:intl/intl.dart';
class ProductModel {
  final String name;
  final String describe;
  final String image;
  final double price;
  int quantity;

  ProductModel({
    required this.name,
    required this.describe,
    required this.image,
    required this.price,
    this.quantity = 1, // Mặc định số lượng là 1
  });

  String get formattedPrice {
    final formatter = NumberFormat("#,###", "vi_VN"); // Định dạng theo chuẩn Việt Nam
    return "${formatter.format(price)} đ"; // Thêm đơn vị "đ"
  }
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String,
      describe: json['describe'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(), // Chuyển đổi int hoặc double thành double
      quantity: json['quantity'] ?? 1,
    );
  }

  // Phương thức chuyển đổi sang JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'describe': describe,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}