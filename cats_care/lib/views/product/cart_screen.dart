import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/product/cart_view_model.dart';

class ShoppingCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        backgroundColor: Colors.white
      ),
      body: cartProvider.cartItems.isEmpty
    ? Center(
        child: Text(
          'Giỏ hàng của bạn đang trống',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
    : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: cartProvider.cartItems.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                var product = cartProvider.cartItems[index];

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      product.image,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${product.price} VNĐ',
                      style: TextStyle(color: Colors.teal),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            cartProvider.decreaseQuantity(product);
                          },
                        ),
                        Text(
                          product.quantity.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            cartProvider.addToCart(product);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Xác nhận'),
                                content: Text('Bạn có chắc muốn xóa sản phẩm này?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      cartProvider.removeFromCart(product);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Đã xóa khỏi giỏ hàng!')),
                                      );
                                    },
                                    child: Text('Xóa'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              border: Border(top: BorderSide(color: Colors.teal, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng cộng:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${cartProvider.cartItems.fold<int>(0, (sum, item) => sum + (item.price * item.quantity).toInt())} VNĐ',
                  style: TextStyle(fontSize: 18, color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}