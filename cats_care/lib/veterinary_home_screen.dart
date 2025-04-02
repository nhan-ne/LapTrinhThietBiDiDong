// home_page.dart
import 'package:flutter/material.dart';
import 'veterinary_card.dart';

class VeterinaryHomePage extends StatefulWidget {
  @override
  _VeterinaryHomePageState createState() => _VeterinaryHomePageState();
}

class _VeterinaryHomePageState extends State<VeterinaryHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<VeterinaryData> _originalVeterinaryData = [];
  List<VeterinaryData> _filteredVeterinaryData = [];

  // Dữ liệu thú y (ví dụ)
  final List<VeterinaryData> _initialVeterinaryData = [
    VeterinaryData(
      name: 'Bệnh viện thú y PETPRO',
      address: 'Địa chỉ: 550 Lũy Bán Bích, P. Hòa Thạnh, Q. Tân Phú, TP.HCM.',
      phone: 'Điện thoại: (028) 38 612977\n0913 949 041',
      hours: 'Giờ làm việc: 24/7 (Ngày lễ có thể thay đổi)',
      image: 'assets/images/veterinary logos/petpro_logo.png',
    ),
    VeterinaryData(
      name: 'Animal Doctors International',
      address:
      'Địa chỉ: 226 Nguyễn Văn Hưởng, Thảo Điền, Thủ Đức và 826 Nguyễn Văn Linh, Phú Mỹ Hưng, Tân Phong, quận 7 - TP.HCM\nHotline: 1900 633 093',
      phone: '',
      hours: 'Giờ mở cửa: 09:00 - 19:00 (7 ngày)\nCấp cứu 24/7.',
      image: 'assets/images/veterinary logos/animal_doctors_logo.png',
    ),
    VeterinaryData(
      name: 'Phòng khám thú y Saigon Veterinary Clinic',
      address:
      'Địa chỉ: 21 đường 14-Quang Trung, phường 8, Gò Vấp, TP.HCM, Việt Nam\nHotline: (+84)8-6273-6470',
      phone: '',
      hours: 'Giờ làm việc: T2 - T7 (8am-5pm), CN (Đóng cửa)',
      image: 'assets/images/veterinary logos/saigon_vet_logo.png',
    ),
    VeterinaryData(
      name: 'Phòng khám thú y K9',
      address:
      'Địa chỉ: số 71 Trần Hưng Đạo, Phường 6, Quận 5, TP.HCM\nĐT: (028) 377 50 894\nCs 1: 61 Bình Giã, P.13, Q. Tân Bình, TP.HCM\n ĐT: 0762 028 028\nCs 2: 52 Huỳnh Đình Hai, P.14, Q. Bình Thạnh, TP.HCM\n ĐT: 0762 029 029\nCs 3: 177 Nguyễn Thị Thập, P. Tân Phú, Quận 7, TP.HCM\n ĐT: 0768 677 577',
      phone: '',
      hours: '',
      image: 'assets/images/veterinary logos/k9_logo.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _originalVeterinaryData = _initialVeterinaryData;
    _filteredVeterinaryData = _initialVeterinaryData;
  }

  void _onSearchChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredVeterinaryData = _originalVeterinaryData;
      } else {
        _filteredVeterinaryData = _originalVeterinaryData
            .where((data) =>
            data.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thú y'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                '"Thú Y cho Mèo - nơi sức khỏe của "hoàng thượng" được đặt lên hàng đầu !',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo tên',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6,
                children: _filteredVeterinaryData
                    .map((data) => VeterinaryCard(
                  name: data.name,
                  address: data.address,
                  phone: data.phone,
                  hours: data.hours,
                  image: data.image,
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class VeterinaryData {
  final String name;
  final String address;
  final String phone;
  final String hours;
  final String image;

  VeterinaryData({
    required this.name,
    required this.address,
    required this.phone,
    required this.hours,
    required this.image,
  });
}