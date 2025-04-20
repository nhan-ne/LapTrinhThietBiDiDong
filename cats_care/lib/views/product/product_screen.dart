import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/product/product_view_model.dart';
import '../../viewmodels/product/cart_view_model.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductViewModel>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    var productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Sản phẩm',
          style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Một số sản phẩm tham khảo giúp thú cưng của anh chị em trở nên ú nụ',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
                    );
                  },
                  icon: Icon(Icons.add_shopping_cart),
                  color: Colors.amber,
                  iconSize: 30,
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: productViewModel.products.isEmpty
                  ? Center(child: CircularProgressIndicator()) // Loading Indicator
                  : GridView.builder(
                      itemCount: productViewModel.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.55,
                      ),
                      itemBuilder: (context, index) {
                        final product = productViewModel.products[index];

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    product.image,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  product.name,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  product.describe,
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${product.price.toStringAsFixed(0)} VNĐ', // Sửa lỗi hiển thị giá
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          var cartViewModel = Provider.of<CartViewModel>(context, listen: false);
                                          cartViewModel.addToCart(product);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Đã thêm vào giỏ hàng!')),
                                          );
                                        },
                                        icon: Icon(Icons.add_shopping_cart),
                                        color: Colors.amber,
                                        iconSize: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

