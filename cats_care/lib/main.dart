import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'login.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScereen()),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFAFCEE),
      body: Padding(
        padding:EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Row(
              children: [
                Text('Chào mừng bạn \nđến với',
                  style:TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
                SizedBox(width: 8,),
                Image.asset("assets/images/meo.png")
              ],
            ),
            Image.asset('assets/images/logo.png')
          ],
        )
      )
      
    );
  }
}
