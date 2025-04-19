import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/views/home/home_page.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  

  User? _user;
  String? _errorMessage;

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
}
