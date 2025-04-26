import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/views/home/home_page.dart';
import '/viewmodels/product/cart_view_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  

  User? _user;
  String? _errorMessage;
  String? _verificationId;

  User? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Hiển thị hộp thoại đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _errorMessage = "User canceled the Google sign-in process.";
        notifyListeners();
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

      // Lấy uid của người dùng
      final String? uid = _user?.uid;
      print("UID của người dùng: $uid");



      _user = userCredential.user;
      _errorMessage = null;
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
      notifyListeners();
    } catch (e) {
      _errorMessage = "$e";
      _user = null;
      notifyListeners();
    }
  }
  Future<void> signOut(BuildContext context) async {
    try {
      Provider.of<CartViewModel>(context, listen: false).clearCart(); // Loại bỏ await      
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      _errorMessage = null;
      notifyListeners();
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      _errorMessage = "Đăng xuất thất bại: $e";
      notifyListeners();
    }
  }

  Future<void> signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
    try {
      print('Đang gửi mã OTP đến: $phoneNumber');

      _auth.setLanguageCode('vi');
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('Xác thực tự động thành công');
          UserCredential userCredential = await _auth.signInWithCredential(credential);
          _user = userCredential.user;
          _errorMessage = null;
          notifyListeners();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Lỗi xác thực: ${e.message}');
          _errorMessage = "Xác thực thất bại: ${e.message}";
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Mã OTP đã được gửi. Verification ID: $verificationId');
          _verificationId = verificationId;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Hết thời gian chờ mã OTP. Verification ID: $verificationId');
          _verificationId = verificationId;
        },
      );
      print('Mã OTP đã được gửi đến: $phoneNumber');
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      print('Lỗi khi gửi mã OTP: $e');
      _errorMessage = "Đăng nhập thất bại: $e";
      notifyListeners();
    }
  }

  Future<void> verifyOTP(BuildContext context, String otp) async {
    try {
      print('Đang xác thực OTP: $otp');
      if (_verificationId == null) {
        print('Không tìm thấy mã xác thực');
        _errorMessage = "Không tìm thấy mã xác thực.";
        notifyListeners();
        return;
      }

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      _errorMessage = null;
      print('Xác thực OTP thành công');
      notifyListeners();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print('Lỗi xác thực OTP: $e');
      _errorMessage = "Xác thực OTP thất bại: $e";
      notifyListeners();
    }
  }
}
