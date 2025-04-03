import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../info_cat.dart';
import '../product/product_list.dart';
import '../../info_account.dart';
import '../../cat_breeds_screen.dart';

class HomePage extends StatefulWidget {
  final User? user;

  HomePage({Key? key, required this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(user: widget.user),
      InfoAccount(user: widget.user),

    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Color(0xff10A37F),
                unselectedItemColor: Colors.grey[400],
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: "Notification",
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox.shrink(), // khoảng trống cho nút +
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: "Chat",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -5,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatInfoForm())
                );
              },
              backgroundColor: const Color(0xff10A37F), // Màu nền nút
              elevation: 0, // Độ nổi mặc định
              highlightElevation: 10, // Độ nổi khi nhấn
              splashColor: Colors.white.withOpacity(0.3), // Màu lan tỏa khi nhấn
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.white, // Màu viền
                  width: 2, // Độ dày viền
                ),
              ),
              child: Icon(
                Icons.add,
                size: 30, // Kích thước biểu tượng lớn hơn
                color: Colors.white, // Màu biểu tượng
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final User? user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          _buildTitle('Kỉ niệm'),
          Center(
            child: Image.asset(
              'assets/images/kiniem.png',
              height: 200,
            ),
          ),
          const SizedBox(height: 20),
          _buildTitle('Dịch Vụ'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildComponentButton(context, 'Giống mèo', Icons.pets, CatBreedsScreen()),
              _buildComponentButton(context, 'Thú y', Icons.local_hospital, ThuYScreen()),
              _buildComponentButton(context, 'Khách sạn mèo', Icons.hotel, KhachSanMeoScreen()),
              _buildComponentButton(context, 'Sản phẩm', Icons.shopping_bag, ProductScreen()),
            ],
          ),
          const SizedBox(height: 10),
          _buildTitle('Tin tức'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 150,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/tintuc.png',
                    height: 100,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Kiếm tiền tỉ mỗi năm nhờ nuôi giống mèo nhà "khổng lồ"',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
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

Widget _buildTitle(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget _buildComponentButton(BuildContext context, String title, IconData icon, Widget destination) {
  return Container(
    width: 75,
    height: 120,
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
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
      appBar: AppBar(title: const Text("Thú y")),
      body: const Center(child: Text("Thú y Page")),
    );
  }
}

class KhachSanMeoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Khách sạn mèo")),
      body: const Center(child: Text("Khách sạn mèo Page")),
    );
  }
}
