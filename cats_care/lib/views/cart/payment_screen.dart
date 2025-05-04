import 'package:cat_care/models/oder_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/viewmodels/cart/cart_view_model.dart';
import '/viewmodels/delivery/delivery_view_model.dart';
import '/models/users_model.dart';
import '/viewmodels/cart/oder_view_model.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Future<List<UserAddress>> _futureAddresses;
  String? selectedAddressId; 

  @override
  void initState() {
    super.initState();
    _futureAddresses = Provider.of<DeliveryViewModel>(context, listen: false).getUserAddresses();
  }
  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Biểu tượng mũi tên quay lại
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff7FDDE5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // DropdownButton để chọn địa chỉ
            FutureBuilder<List<UserAddress>>(
              future: _futureAddresses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có địa chỉ nào được lưu.'));
                } else {
                  final addresses = snapshot.data!;

                  if (selectedAddressId == null && addresses.isNotEmpty) {
                    selectedAddressId = addresses[0].id;
                  }
                  return DropdownButton<String>(
                        value: selectedAddressId,
                        isExpanded: true,
                        underline: SizedBox.shrink(),
                        items: addresses.map((address) {
                          return DropdownMenuItem<String>(
                            value: address.id, // Sử dụng ID duy nhất
                            child: Text('${address.name} - ${address.address}'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedAddressId = newValue; // Cập nhật ID được chọn
                            });
                          }
                        },
                      );
                }
              },
            ),
            const SizedBox(height: 16),
            // Danh sách sản phẩm
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartViewModel.cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartViewModel.cartItems[index];
                  final total = cartViewModel.totalPerProduct[product.name] ?? 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${product.quantity} x ${product.price.toStringAsFixed(0)} đ',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  Text(
                                    '${total}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Tổng cộng và phương thức thanh toán
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tổng cộng:',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${cartViewModel.formattedTotalPrice}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phương thức thanh toán',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RadioListTile(
                    title: const Text('Tiền mặt'),
                    value: 'cash',
                    groupValue: cartViewModel.paymentMethod,
                    onChanged: (value) {
                      cartViewModel.setPaymentMethod(value.toString());
                    },
                  ),
                  RadioListTile(
                    title: const Text('Chuyển khoản'),
                    value: 'bank_transfer',
                    groupValue: cartViewModel.paymentMethod,
                    onChanged: (value) {
                      cartViewModel.setPaymentMethod(value.toString());
                    },
                  ),
                  RadioListTile(
                    title: const Text('ZaloPay'),
                    value: 'zalopay',
                    groupValue: cartViewModel.paymentMethod,
                    onChanged: (value) {
                      cartViewModel.setPaymentMethod(value.toString());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xff7FDDE5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  if (selectedAddressId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn địa chỉ giao hàng!')),
                    );
                    return;
                  }

                  final addresses = await _futureAddresses;

                  // Tìm địa chỉ được chọn dựa trên selectedAddressId
                  final selectedAddress = addresses.firstWhere(
                    (address) => address.id == selectedAddressId,
                    orElse: () => throw Exception('Không tìm thấy địa chỉ được chọn'),
                  );

                  final orderId = DateTime.now().millisecondsSinceEpoch.toString();
                  final order = OrderModel(
                    orderId: orderId,
                    products: List.from(cartViewModel.cartItems), // Sao chép danh sách sản phẩm
                    totalPrice: cartViewModel.formattedTotalPrice,
                    paymentMethod: cartViewModel.paymentMethod,
                    address: selectedAddress.address,
                    orderDate: DateTime.now(),
                  );

                  try {
                    // Lưu đơn hàng lên Firestore
                    await Provider.of<OrderViewModel>(context, listen: false).saveOrderToFirestore(order);

                    cartViewModel.clearCart();

                    // Hiển thị thông báo thành công
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đặt hàng thành công!')),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi đặt hàng: $e')),
                    );
                  }
                },
                child: const Text(
                  'Xác nhận thanh toán',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
} 