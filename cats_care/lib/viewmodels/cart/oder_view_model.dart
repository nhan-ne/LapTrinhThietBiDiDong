import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/models/oder_model.dart';

class OrderViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hàm lưu đơn hàng lên Firestore
  Future<void> saveOrderToFirestore(OrderModel order) async {
    try {

      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final String uid = user.uid;

      final orderData = order.toJson();
      orderData['uid'] = uid; // Thêm UID vào dữ liệu đơn hàng

      // Lưu đơn hàng vào Firestore
      await _firestore.collection('orders').add(orderData);

      print('Đơn hàng đã được lưu thành công với UID: $uid');
    } catch (e) {
      print('Lỗi khi lưu đơn hàng: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getOrderHistory() {
    try {
  
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final String uid = user.uid;

  
      return _firestore
          .collection('orders')
          .where('uid', isEqualTo: uid) // Lọc theo UID
          .snapshots();
    } catch (e) {
      print('Lỗi khi lấy lịch sử đơn hàng: $e');
      rethrow;
    }
  }
}