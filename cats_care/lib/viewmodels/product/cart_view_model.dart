import 'package:flutter/material.dart';
import '/models/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final List<ProductModel> _cartItems = [];

  List<ProductModel> get cartItems => _cartItems;

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(ProductModel product) {
    var existingProduct = _cartItems.firstWhere(
      (item) => item.name == product.name,
      orElse: () => ProductModel(  // Trả về một sản phẩm mặc định nếu không tìm thấy
        name: product.name,
        describe: product.describe,
        image: product.image,
        price: product.price,
        quantity: 0,  // Đảm bảo quantity mặc định là 0 để dễ dàng thêm vào
      ),
    );

    if (existingProduct.quantity > 0) {
      existingProduct.quantity++;  // Tăng số lượng
    } else {
      product.quantity = 1;  // Nếu sản phẩm chưa có, đặt quantity = 1
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
}
