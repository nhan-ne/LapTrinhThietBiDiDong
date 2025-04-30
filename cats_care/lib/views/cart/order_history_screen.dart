import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '/viewmodels/cart/oder_view_model.dart';
import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  return formatter.format(amount);
}
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Stream<QuerySnapshot> _orderStream;
  final Map<int, bool> _expandedStates = {};
  
  

  @override
  void initState() {
    super.initState();
    _orderStream = Provider.of<OrderViewModel>(context, listen: false).getOrderHistory();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5F8FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Lịch sử đơn hàng',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff7FDDE5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách các đơn hàng:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff9C9C9C),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Không có đơn hàng nào.'));
                  } else {
                    final orders = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final orderData = order.data() as Map<String, dynamic>;
                        final products = orderData['products'] as List<dynamic>; // Lấy danh sách sản phẩm
                        final productData = products.first as Map<String, dynamic>;
                        final bool isExpanded = _expandedStates[index] ?? false;

                        final double price = double.tryParse(productData['price'].toString()) ?? 0;
                        final int quantity = int.tryParse(productData['quantity'].toString()) ?? 0;
                        final double totalPricePerProduct = price * quantity; 

                        return GestureDetector(
                          onTap: () {
                            // Xử lý khi nhấn vào đơn hàng (hiển thị chi tiết nếu cần)
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [  
                                // Hien thi san pham dau tien
                                buildProductItem(productData),                                                       
                                if (!isExpanded && products.length > 1)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _expandedStates[index] = true; // Mở rộng danh sách
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, // Giúp nút không chiếm hết chiều ngang
                                      children: const [
                                        Text(
                                          'Xem thêm',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 4), // khoảng cách giữa text và icon
                                        Icon(
                                          Icons.expand_more_rounded,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                if (isExpanded)
                                  Column(
                                    children: products.skip(1).map((product) {
                                      final productData = product as Map<String, dynamic>;
                                      return buildProductItem(productData);
                                    }).toList(),
                                  ),
                                SizedBox(height: 8),
                                // Hien thi tong so tien
                                buildTotalPrice(formatCurrency(totalPricePerProduct)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget buildProductItem(Map<String, dynamic> productData) {
  final double price = double.tryParse(productData['price'].toString()) ?? 0;
  final int quantity = int.tryParse(productData['quantity'].toString()) ?? 0;
  final double totalPricePerProduct = price * quantity;

  return Row(
    children: [
      // Hình ảnh sản phẩm
      Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(productData['image'] ?? 'assets/images/default_product.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),

      // Thông tin sản phẩm
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productData['name'] ?? 'Tên sản phẩm',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productData['describe'] ?? 'Mô tả sản phẩm',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'x${productData['quantity'] ?? 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formatCurrency(totalPricePerProduct),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildTotalPrice(String totalPrice) {
  return Align(
    alignment: Alignment.centerRight,
    child: Text(
      'Tổng số tiền: $totalPrice',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
      textAlign: TextAlign.right,
    )
  );
}