import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/auth/login_screen.dart';
import 'viewmodels/product/product_view_model.dart';
import 'viewmodels/auth/auth_view_model.dart';
import 'viewmodels/cart/cart_view_model.dart';
import 'viewmodels/delivery/location_view_model.dart';
import 'viewmodels/delivery/delivery_view_model.dart';
import 'viewmodels/cart/oder_view_model.dart';

import 'viewmodels/information/cat_list_view_model.dart';
import 'viewmodels/information/cat_information_view_model.dart';
//import 'viewmodels/cat_list/cat_list_view_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ProductViewModel()),    
        ChangeNotifierProvider(create: (context) => CartViewModel()),
        ChangeNotifierProvider(create: (context) => DeliveryViewModel()),
        ChangeNotifierProvider(create: (context) => LocationViewModel()),
        ChangeNotifierProvider(create: (context) => OrderViewModel()),
  
        ChangeNotifierProvider(create: (context) => CatListViewModel()),
        ChangeNotifierProvider(create: (_) => AddCatViewModel()),
        // ChangeNotifierProvider(create: (context) => CatCalendarViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFE5F8FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 71),
            Row(
              children: [
                const Text(
                  'Chào mừng bạn \nđến với',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset("assets/images/meo.png", height: 110),
              ],
            ),
            Container(
              width: 360,
              height: 360,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Spacer(),
             InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: 285,
                  decoration: BoxDecoration(
                    color: Color(0xff7FDDE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
