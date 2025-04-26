import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


import '/viewmodels/delivery/location_view_model.dart';
import '/viewmodels/delivery/delivery_view_model.dart';

class AddAddressScreen  extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _DeliveryState();
}

class _DeliveryState extends State<AddAddressScreen> {
  final LocationViewModel _locationViewModel = LocationViewModel();  
  final DeliveryViewModel _deliveryViewModel = DeliveryViewModel();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String selectedAddressType = 'Nhà riêng';
  bool _isLoading = false;
  bool _isDefault = false;
  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffE5F8FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Thông tin giao hàng',
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                        _addressController.text = address;
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập họ và tên';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _phoneController,
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                            return 'Số điện thoại không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _addressController,
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập địa chỉ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _noteController,
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
                )
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xff7FDDE5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {

              await _deliveryViewModel.saveUserAddresses(
                name: _nameController.text,
                phone: _phoneController.text,
                address: _addressController.text,
                note: _noteController.text,
                addressType: selectedAddressType,
                isDefault: _isDefault,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Địa chỉ đã được lưu thành công!'),
                ),
              );
              Navigator.pop(context, true);
            } else {
          
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Thiếu thông tin'),
                  content: const Text('Vui lòng điền đầy đủ thông tin trước khi tiếp tục.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Đóng'),
                    ),
                  ],
                ),
              );
            } 
          },
          child: const Text(
            'HOÀNG THÀNH',
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