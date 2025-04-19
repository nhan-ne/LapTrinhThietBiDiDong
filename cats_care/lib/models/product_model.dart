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

  // Phương thức factory từ JSON, đảm bảo price là double
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      describe: json['describe'],
      image: json['image'],
      price: _parsePrice(json['price']), // Gọi hàm xử lý giá
      quantity: json['quantity'] ?? 1,
    );
  }

  // Hàm xử lý giá từ chuỗi JSON
  static double _parsePrice(String? price) {
    if (price == null) return 0.0;
    // Loại bỏ các ký tự không phải số và dấu chấm
    String cleanedPrice = price.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanedPrice) ?? 0.0;
  }
}