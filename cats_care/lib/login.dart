import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:cat_care/home_page.dart';

class LoginScereen extends StatefulWidget {
  const LoginScereen({super.key});
  @override
  _LoginScereen createState() => _LoginScereen();
}

class _LoginScereen extends State<LoginScereen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController phoneController = TextEditingController();
  User? _user;
  String? _errorMessage;

  Future<void> signInWithGoogle() async {
    try {
      // Hiển thị hộp thoại đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _errorMessage = "User canceled the Google sign-in process.";
          _user = null;
        });
        return;
      }

      // Lấy thông tin xác thực từ tài khoản Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      setState(() {
        _user = userCredential.user;
        _errorMessage = null;
      });
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: _user,)),
        );
      });
      
    } catch (e) {
      setState(() {
        _errorMessage = "$e";
        _user = null;
      });
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      _user = null;
      _errorMessage = null;
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding:EdgeInsets.all(16),
          child: Column (
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo.png', width: 150),
              SizedBox(height: 10,),
              Text(
              'Đăng nhập',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xff616161)
                ),
              ),
              SizedBox(height: 20,),
              
              TextField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  label: Text("Số điện thoại",
                    
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xff10A37F)),  // Viền màu xanh
                  ),
                ),
              ),
              SizedBox(height: 16,),
               Container(
                height: 62,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff10A37F) ,
                  borderRadius:BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '+84${phoneController.text}',
                    verificationCompleted: (PhoneAuthCredential credential) async {
                      await FirebaseAuth.instance.signInWithCredential(credential);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(user: FirebaseAuth.instance.currentUser),
                        ),
                      );
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Xác thực thất bại: ${e.message}')),
                      );
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPScreen(verificationId: verificationId),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text('Tiếp tục',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              ),
              SizedBox(height: 16,),
              Text('HOẶC',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff616161)
                ),
              ),
              SizedBox(height: 16,),
              Container(
                alignment:Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(8),
                  border: Border.all(color: Color(0xff10A37F)) 
                ),
                child: ElevatedButton.icon(
                  icon: Image.asset('assets/images/icon/google.png'),
                  label: Text('Tiếp tục với google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff616161),
                    ),
                  ),
                  onPressed: signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                  ),
                )
              ),
              SizedBox(height: 20),

              // Hiển thị thông báo lỗi nếu có
              if (_errorMessage != null)
                _buildMessage(Colors.red, "Google Sign-In Failed", _errorMessage!),

              // Hiển thị thông báo thành công nếu đăng nhập thành công
              if (_user != null)                  
                _buildMessage(Colors.green, "Đăng nhập thành công!", " Chào ${_user!.email}"),
            ],
          )
        )
      )
    );
  }
}

// Hàm tái sử dụng hiển thị thông báo
Widget _buildMessage(Color color, String title, String message) {
  return Container(
    padding: EdgeInsets.all(20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

class OTPScreen extends StatelessWidget {
  final String verificationId;
  final TextEditingController otpController = TextEditingController();

  OTPScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Xác thực OTP"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo.png', width: 150),
              Text(
              'Đăng nhập',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xff616161)
                ),
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.phone,
                controller: otpController,
                cursorColor: Color(0xff224D55),  // Màu con trỏ
                decoration: InputDecoration(
                  label: Text("Số điện thoại",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),  
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 62,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff10A37F) ,
                  borderRadius:BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: otpController.text,
                      );
                      await FirebaseAuth.instance.signInWithCredential(credential);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(user: FirebaseAuth.instance.currentUser),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Xác thực OTP thất bại: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text('Xác nhận OTP',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
