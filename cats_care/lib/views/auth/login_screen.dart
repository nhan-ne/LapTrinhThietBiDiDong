import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:cat_care/views/home/home_page.dart';

import '../../viewmodels/auth/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final TextEditingController phoneController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding:EdgeInsets.all(16),
          child: Column (
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo.png', width: 230),
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
                  color: Color(0xff7FDDE5) ,
                  borderRadius:BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                onPressed: () async {
                  if (phoneController.text.isEmpty || phoneController.text.length < 9) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vui lòng nhập số điện thoại hợp lệ')),
                    );
                    return;
                  }

                  // Chuyển đổi số điện thoại
                  String formattedPhone = phoneController.text;
                  if (formattedPhone.startsWith('0')) {
                    formattedPhone = '+84${formattedPhone.substring(1)}';
                  }

                  // Gửi mã OTP qua AuthViewModel
                  await authViewModel.signInWithPhoneNumber(context, formattedPhone);
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
                  onPressed: () => authViewModel.signInWithGoogle(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                  ),
                )
              ),
              SizedBox(height: 20),

              // Hiển thị thông báo lỗi nếu có
              if (authViewModel.errorMessage != null)
                _buildMessage(Colors.red, "Google Sign-In Failed", authViewModel.errorMessage!),

              // Hiển thị thông báo thành công nếu đăng nhập thành công
              if (authViewModel.user != null)                  
                _buildMessage(Colors.green, "Đăng nhập thành công!", " Chào ${authViewModel.user!.email}"),
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
                          builder: (context) => HomePage(),
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
 