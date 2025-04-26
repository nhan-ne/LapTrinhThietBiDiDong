import 'package:flutter/material.dart';
import '/models/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final List<ProductModel> _cartItems = [];
  String _paymentMethod = 'cash';

  // Lấy danh sách sản phẩm trong giỏ hàng
  List<ProductModel> get cartItems => _cartItems;

  // Lấy phương thức thanh toán hiện tại
  String get paymentMethod => _paymentMethod;

  // Cập nhật phương thức thanh toán
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(ProductModel product) {
    var existingProduct = _cartItems.firstWhere(
      (item) => item.name == product.name,
      orElse: () => ProductModel(
        name: product.name,
        describe: product.describe,
        image: product.image,
        price: product.price,
        quantity: 0,
      ),
    );

    if (existingProduct.quantity > 0) {
      existingProduct.quantity++;
    } else {
      product.quantity = 1;
      _cartItems.add(product);
    }
    notifyListeners();
  }

  // Giảm số lượng sản phẩm trong giỏ hàng
  void decreaseQuantity(ProductModel product) {
    var existingProduct = _cartItems.firstWhere(
      (item) => item.name == product.name,
      orElse: () => ProductModel(
        name: product.name,
        describe: product.describe,
        image: product.image,
        price: product.price,
        quantity: 0,
      ),
    );

    if (existingProduct.quantity > 1) {
      existingProduct.quantity--;
      notifyListeners();
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(ProductModel product) {
    _cartItems.removeWhere((item) => item.name == product.name);
    notifyListeners();
  }
  
  // Xóa tất cả sản phẩm trong giỏ hàng
  void clearCart() {
    if (_cartItems.isNotEmpty) {
      _cartItems.clear();
      _paymentMethod = 'cash'; // Đặt lại phương thức thanh toán
      notifyListeners();
    }
  }
  // Tính tổng giá trị giỏ hàng
  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Tính tổng cộng giá trị của mỗi loại sản phẩm
  Map<String, double> get totalPerProduct {
    return _cartItems.asMap().map((index, item) {
      return MapEntry(item.name, item.price * item.quantity);
    });
  }
}