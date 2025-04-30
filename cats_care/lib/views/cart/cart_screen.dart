import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart/cart_view_model.dart';
import 'payment_screen.dart';

class ShoppingCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Biểu tượng mũi tên quay lại
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff7FDDE5),
      ),
      body: cartViewModel.cartItems.isEmpty
    ? Center(
        child: Text(
          'Giỏ hàng của bạn đang trống',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
    : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: cartViewModel.cartItems.length,
              itemBuilder: (context, index) {
                var product = cartViewModel.cartItems[index];
                final total = cartViewModel.totalPerProduct[product.name] ?? 0;

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
                      '${total}',
                      style: TextStyle(color: Colors.teal),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            cartViewModel.decreaseQuantity(product);
                          },
                        ),
                        Text(
                          product.quantity.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            cartViewModel.addToCart(product);
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
                                      cartViewModel.removeFromCart(product);
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
              color: Color(0xffE5F8FA),
              border: Border(
                top: BorderSide(color: Color(0xff7FDDE5), width: 1)
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng cộng:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${cartViewModel.formattedTotalPrice}',
                  style: TextStyle(fontSize: 18, color: Colors.teal, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to payment screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Thanh toán',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xff7FDDE5),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}