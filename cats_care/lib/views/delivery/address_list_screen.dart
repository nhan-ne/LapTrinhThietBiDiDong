import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/viewmodels/delivery/delivery_view_model.dart';
import 'add_address.dart';
import 'edit_address.dart';
import '/models/users_model.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late Future<List<UserAddress>> _futureAddresses;

  @override
  void initState() {
    super.initState();
    _loadAddresses(); // Tải danh sách địa chỉ ban đầu
  }

  void _loadAddresses() {
    _futureAddresses = Provider.of<DeliveryViewModel>(context, listen: false).getUserAddresses();
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
          'Danh sách địa chỉ',
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Danh sách các địa chỉ đã lưu:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff9C9C9C),
              ),
              textAlign: TextAlign.left,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5, // Giới hạn chiều cao tối đa
              
            ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FutureBuilder<List<UserAddress>>(
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
                      return ListView.builder(
                        shrinkWrap: true, // Cho phép ListView chiếm chiều cao nhỏ nhất cần thiết
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final address = addresses[index];
                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditAddressScreen(address: address),
                                ),
                              );
                              if (result == true) {
                                // Làm mới danh sách địa chỉ
                                setState(() {
                                  _loadAddresses();
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        address.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        address.phone,
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    address.address,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff595959),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (address.note.isNotEmpty)
                                    Text(
                                      'Ghi chú: ${address.note}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff595959),
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Loại địa chỉ: ${address.addressType}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff595959),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (address.isDefault) 
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffE5F8FA),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: const Color(0xff7FDDE5),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Text(
                                        'Mặc định',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff7FDDE5),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xff7FDDE5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddAddressScreen()),
            );
            if (result == true) {
              // Làm mới danh sách địa chỉ sau khi thêm mới
              setState(() {
                _loadAddresses();
              });
            }
          },
          child: const Text(
            'Thêm địa chỉ mới',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}