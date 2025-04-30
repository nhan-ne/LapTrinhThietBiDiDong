import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '/views/home/home_page.dart';
import '../cart/cart_view_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  

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

      _user = userCredential.user;
      
      // Lấy uid của người dùng
      final String? uid = _user?.uid;
      print("UID của người dùng: $uid");

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

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      // Khởi động đăng nhập Facebook
      final LoginResult result = await _facebookAuth.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        // Lấy access token từ Facebook
        final AccessToken? accessToken = result.accessToken;
        if (accessToken == null) {
          _errorMessage = "Không lấy được access token từ Facebook.";
          notifyListeners();
          return;
        }

        // Tạo credential cho Firebase
        final AuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        // Đăng nhập vào Firebase
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        _user = userCredential.user;

        // Lấy UID của người dùng
        final String? uid = _user?.uid;
        print("UID của người dùng: $uid");

        _errorMessage = null;

        // Chuyển hướng đến HomePage sau 2 giây
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
      } else {
        _errorMessage = "Đăng nhập Facebook thất bại: ${result.message}";
      }
      notifyListeners();
    } catch (e) {
      print('Lỗi đăng nhập bằng Facebook: $e');
      _errorMessage = "Đăng nhập thất bại: $e";
      _user = null;
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      Provider.of<CartViewModel>(context, listen: false).clearCart();     
      await _googleSignIn.signOut();
      await _facebookAuth.logOut();
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
