import 'package:flutter/material.dart';
import '/models/product_model.dart';
import 'package:intl/intl.dart';

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
      
    } else {
      _cartItems.remove(existingProduct);
    }
    notifyListeners();
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(ProductModel product) {
    _cartItems.removeWhere((item) => item.name == product.name);
    notifyListeners();
  }
  
  void clearCart() {
    if (_cartItems.isNotEmpty) {
      _cartItems.clear();
      _paymentMethod = 'cash';
      notifyListeners();
    }
  }
  
  String get formattedTotalPrice {
    final total = _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(total)} đ";
  }

  // Tính tổng cộng giá trị của mỗi loại sản phẩm
  Map<String, String> get totalPerProduct {
    final formatter = NumberFormat("#,###", "vi_VN");
    return _cartItems.asMap().map((index, item) {
      final formattedPrice = formatter.format(item.price * item.quantity);
      return MapEntry(item.name, "$formattedPrice đ");
    });
  }
}