import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '/viewmodels/delivery/location_view_model.dart';
import '/viewmodels/delivery/delivery_view_model.dart';
import '/models/users_model.dart';

class EditAddressScreen extends StatefulWidget {
  final UserAddress address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController noteController;
  bool _isLoading = false;
  late String selectedAddressType;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.address.name);
    phoneController = TextEditingController(text: widget.address.phone);
    addressController = TextEditingController(text: widget.address.address);
    noteController = TextEditingController(text: widget.address.note);
    selectedAddressType = widget.address.addressType;
    _isDefault = widget.address.isDefault;
  }

  @override
  Widget build(BuildContext context) {
    final _deliveryViewModel = Provider.of<DeliveryViewModel>(context, listen: false);
    final _locationViewModel = Provider.of<LocationViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xffE5F8FA),
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa địa chỉ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xffF6F7F7),
          ),
        ),
        backgroundColor: const Color(0xff7FDDE5),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () async {
                  if (_isLoading) return;
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    // Lấy vị trí hiện tại
                    Position position = await _locationViewModel.getCurrentPosition();
                    print('Vị trí hiện tại: ${position.latitude}, ${position.longitude}');

                    // Chuyển đổi tọa độ thành địa chỉ
                    String address = await _locationViewModel.getAddressFromLatLng(position);
                    print('Địa chỉ: $address');

                    // Hiển thị địa chỉ trong giao diện
                    setState(() {
                      addressController.text = address;
                    });
                  } catch (e) {
                    // Hiển thị lỗi bằng SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: $e')),
                    );
                  }finally {
                    setState(() {
                      _isLoading = false; 
                    });
                  }
                },
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/icon/Vector.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Lấy địa chỉ hiện tại của bạn',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff595959),
                      )
                    ),
                    const Spacer(),
                    if (_isLoading == true)
                      CircularProgressIndicator(
                        color: Color(0xff7FDDE5),
                      )
                    else
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xff7FDDE5),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Họ và tên',
                      labelStyle: const TextStyle(
                        color: Color(0xff9C9C9C),
                      ),
                      border:UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffD3D3D3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      labelStyle: const TextStyle(
                        color: Color(0xff9C9C9C),
                      ),
                      border:UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffD3D3D3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ',
                      labelStyle: const TextStyle(
                        color: Color(0xff9C9C9C),
                      ),
                      border:UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffD3D3D3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Ghi chú',
                     labelStyle: const TextStyle(
                        color: Color(0xff9C9C9C),
                      ),
                      border:UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffD3D3D3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column (
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đặt làm địa chỉ mặc định',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff595959),
                        ),
                      ),
                      Switch(
                        value: _isDefault,
                        onChanged: (value) {
                          setState(() {
                            _isDefault = value;
                          });
                        },
                        activeColor: const Color(0xff7FDDE5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Loại địa chỉ:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff595959),
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('Nhà riêng'),
                        selected: selectedAddressType == 'Nhà riêng',
                        onSelected: (selected) {
                          setState(() {
                            selectedAddressType = 'Nhà riêng';
                          });
                        },
                        backgroundColor: const Color(0xffE6E6E6),
                        selectedColor: const Color(0xff7FDDE5),
                        labelStyle: TextStyle(
                          color: selectedAddressType == 'Nhà riêng'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('Văn phòng'),
                        selected: selectedAddressType == 'Văn phòng',
                        onSelected: (selected) {
                          setState(() {
                            selectedAddressType = 'Văn phòng';
                          });
                        },
                        backgroundColor: const Color(0xffE6E6E6),
                        selectedColor: const Color(0xff7FDDE5),
                        labelStyle: TextStyle(
                          color: selectedAddressType == 'Văn phòng'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 130),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xff7FDDE5),
                      width: 1,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      _deliveryViewModel.deleteUserAddress(widget.address.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Địa chỉ đã được xóa'),
                        ),
                      );
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Xoá địa chỉ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff7FDDE5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xff7FDDE5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      // Lưu dữ liệu vào Firestore
                      await _deliveryViewModel.updateUserAddress(
                        id: widget.address.id,
                        name: nameController.text,
                        phone: phoneController.text,
                        address: addressController.text,
                        note: noteController.text,
                        addressType: selectedAddressType,
                        isDefault: _isDefault,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Địa chỉ đã được cập nhật'),
                        ),
                      );
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'HOÀN THÀNH',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}