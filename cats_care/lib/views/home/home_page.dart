import 'package:cat_care/views/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth/auth_view_model.dart';
import 'profile.dart';
import '../../cat_breeds_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      InfoAccount(),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xff7FDDE5),
        unselectedItemColor: const Color(0xffB8B8B8),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Lịch",
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static List<Map<String, String>> newsList = [
    {
      "title": "10 điều cần biết dành cho người mới nuôi mèo",
      "image": "assets/images/new/news1.png",
    },
    {
      "title": "Những điều thú vị về loài mèo",
      "image": "assets/images/new/news2.png",
    },
    {
      "title": "Mẹo chải lông mèo",
      "image": "assets/images/new/news3.png",
    },
  ];

  Widget _buildNewsItem(BuildContext context, String title, String imagePath) {
    return Container(
      width: 150, 
      margin: const EdgeInsets.only(right: 10), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 150, 
              height: 100, 
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Hi, ${authViewModel.user?.displayName ?? ''}",
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(authViewModel.user?.photoURL ?? ''),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoAccount(), 
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16), 
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16), 
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/anh.png",
                  width: double.infinity,
                  height: 200, 
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16), 
              _buildTitle('Dịch vụ'),
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildComponentButton(context, "Giống mèo", "assets/images/icon/giong_meo.png", CatBreedsScreen()),
                    _buildComponentButton(context, "Thú y", "assets/images/icon/thu_y.png", ThuYScreen()),
                    _buildComponentButton(context, "Sản phẩm", "assets/images/icon/san_pham.png", ProductScreen()),
                    _buildComponentButton(context, "Khách sạn mèo", "assets/images/icon/hotel.png", KhachSanMeoScreen()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildTitle('Tin tức'),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return _buildNewsItem(context, news['title']!, news['image']!);
                  },
                ),
              ),
            ],
          ),
        ),
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

Widget _buildComponentButton(BuildContext context, String title, String imagePath, Widget destination) {
  return SizedBox(
    width: 80,
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
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xff99E4EA),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),
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