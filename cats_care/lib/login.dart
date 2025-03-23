import 'package:flutter/material.dart';

class Login extends StatelessWidget{
   final TextEditingController phoneController = TextEditingController();

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:EdgeInsets.all(16),
          child: Column (
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo.png', width: 150),
              
              Text(
                'Login',
                style: TextStyle(
                  color: Color(0xffFBDECC),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),

              TextField(
                keyboardType: TextInputType.number,
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Số điện thoại",
                   border: OutlineInputBorder(),
                
                )
              ),
              SizedBox(height: 20,),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:Color(0xffFFB315),
                  borderRadius:BorderRadius.circular(8)
                ),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPScreen(phoneNumber: phoneController.text),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      textStyle: TextStyle(fontSize: 18,),
                  ),
                  child: Text('Xác nhận',
                  
                  )
                )
              )           
            ],
          )
        )
      )
    );
  }
}

// Màn hình nhập mã OTP
class OTPScreen extends StatelessWidget {
  final String phoneNumber;
  final TextEditingController otpController = TextEditingController();

  OTPScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: const Text("Xác thực OTP"),
          
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo.png', width: 150),

              Text(
                'Nhập mã OTP gửi đến\n$phoneNumber',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: "Mã OTP",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFFB315),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // // Xử lý xác thực OTP ở đây
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Xác nhận OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Màn hình chính sau khi xác thực OTP