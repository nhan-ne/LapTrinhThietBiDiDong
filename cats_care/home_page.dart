import 'package:flutter/material.dart';
import 'product.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền chính
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              _buildTitle('Kỉ niệm'),

              Center(
                child: Image.asset('assets/images/kiniem.png', height: 200), // Hình ảnh minh họa
              ),
              SizedBox(height: 20),

              _buildTitle('Dịch Vụ'),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildComponentButton(context, 'Giống mèo', Icons.pets, GiongMeoScreen()),
                  _buildComponentButton(context, 'Thú y', Icons.local_hospital, ThuYScreen()),
                  _buildComponentButton(context, 'Khách sạn mèo', Icons.hotel, KhachSanMeoScreen()),
                  _buildComponentButton(context, 'Sản phẩm', Icons.shopping_bag, SanPhamScreen()),
                ],
              ),
              SizedBox(height: 20),
 
              _buildTitle('Tin tức'),
              SizedBox(height: 10),

              Container(
                width: double.infinity,
                height:150,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white, // Màu nền hộp tin tức
                  borderRadius: BorderRadius.circular(12), // Bo góc mềm mại
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, 
                      blurRadius: 5, 
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Bo góc ảnh
                      child: Image.asset(
                        'assets/images/tintuc.png',
                        height: 100,
                        width: 120,
                        fit: BoxFit.cover, 
                      ),
                    ),
                    SizedBox(width: 10), // Khoảng cách giữa ảnh và văn bản
                    Expanded(
                      child: Text(
                        'Kiếm tiền tỉ mỗi năm nhờ nuôi giống mèo nhà "khổng lồ"',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis, // Nếu dài quá thì hiển thị "..."
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white, // Màu viền
              width: 1.5, // Độ dày viền
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFE78D21), 
          selectedItemColor: Colors.black, // Màu khi được chọn
          unselectedItemColor: Colors.white, // Màu mặc định
          currentIndex: 0, // Chỉ mục mặc định
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Trang chủ",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Tài khoản",
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTitle(String text) {
  return Text(
    text,
    style: TextStyle(
      color: Color(0xFFD8AE52), // Màu vàng phối
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildComponentButton(BuildContext context, String title, IconData icon, Widget destination) {
  return Container(
    height: 105,
    width: 75,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(
        colors: [Color(0xFFE78D21), Color(0xFFF09347)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => destination )
          );
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0, // Không có hiệu ứng bóng
        padding: EdgeInsets.all(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

class ThuYScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Khách sạn mèo")),
      body: Center(child: Text("Khách sạn mèo Page")),
    );
  }
}

class GiongMeoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Khách sạn mèo")),
      body: Center(child: Text("Khách sạn mèo Page")),
    );
  }
}

class KhachSanMeoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Khách sạn mèo")),
      body: Center(child: Text("Khách sạn mèo Page")),
    );
  }
}

