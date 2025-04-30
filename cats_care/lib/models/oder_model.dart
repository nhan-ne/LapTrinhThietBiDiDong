import 'product_model.dart';
class OrderModel {
  final String orderId;
  final List<ProductModel> products;
  final String totalPrice;
  final String paymentMethod;
  final String address;
  final DateTime orderDate;

  OrderModel({
    required this.orderId,
    required this.products,
    required this.totalPrice,
    required this.paymentMethod,
    required this.address,
    required this.orderDate,
  });

  // Chuyển đổi sang Map để lưu lên Firestore
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'products': products.map((product) => product.toJson()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'address': address,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  // Chuyển đổi từ Map sang OrderModel
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      products: (json['products'] as List)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList(),
      totalPrice: json['totalPrice'],
      paymentMethod: json['paymentMethod'],
      address: json['address'],
      orderDate: DateTime.parse(json['orderDate']),
    );
  }
}