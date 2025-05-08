import 'package:cat_care/views/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/auth_view_model.dart';
import '../catbreeds/cat_breeds_screen.dart';
import '../cathotel/cat_hotel_home_screen.dart';
import '../veterinary/veterinary_home_screen.dart';
import 'cat_calendar_screen.dart';
//import 'notification_screen.dart';
import 'profile.dart';

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
      CatCalendarScreen(),
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
        selectedItemColor: Color(0xff7FDDE5),
        unselectedItemColor: Color(0xffB8B8B8),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Lịch",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
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
      "image": "assets/images/news/news1.png",
    },
    {
      "title": "Những điều thú vị về loài mèo",
      "image": "assets/images/news/news2.png",
    },
    {
      "title": "Mẹo chải lông mèo",
      "image": "assets/images/news/news3.png",
    },
  ];

  Widget _buildNewsItem(BuildContext context, String title, String image) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Container(
    width: screenWidth * 0.4, // Width is 40% of the screen width
    margin: EdgeInsets.only(right: screenWidth * 0.025), // Margin is 2.5% of the screen width
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth * 0.025), // Border radius is 2.5% of the screen width
          child: Image.asset(
            image,
            width: screenWidth * 0.4, // Image width matches the container width
            height: screenWidth * 0.25, // Height is 25% of the screen width
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: screenWidth * 0.02), // Spacing is 2% of the screen width
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.035, // Font size is 3.5% of the screen width
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
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

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
                    onPressed: () {
                      //Navigator.push(
                        //context,
                        //MaterialPageRoute(builder: (context) => NotificationScreen()),
                      //);
                    },
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(authViewModel.user?.photoURL ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.02), 
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/anh.png",
                  width: double.infinity,
                  height: screenHeight * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTitle('Dịch vụ'),
              SizedBox(height: screenHeight * 0.01), 
              SizedBox(
                height: screenHeight * 0.13, // 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildComponentButton(context, "Giống mèo", "assets/images/icon/giong_meo.png", CatBreedsScreen()),
                    _buildComponentButton(context, "Thú y", "assets/images/icon/thu_y.png", VeterinaryHomePage()),
                    _buildComponentButton(context, "Sản phẩm", "assets/images/icon/san_pham.png", ProductScreen()),
                    _buildComponentButton(context, "Khách sạn mèo", "assets/images/icon/hotel.png", CatHotelHomePage()),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTitle('Tin tức'),
              SizedBox(height: screenHeight * 0.01), 
              SizedBox(
                height: screenHeight * 0.2,
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
  final screenWidth = MediaQuery.of(context).size.width;

  return SizedBox(
    width: screenWidth * 0.2,
    height: screenWidth * 0.3,
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
            height: screenWidth * 0.15,
            width: screenWidth * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.075),
              color: const Color(0xff99E4EA),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.04), // Khoảng cách giữa hình ảnh và tiêu đề
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
