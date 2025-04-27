import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/users_model.dart';

class DeliveryViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Khai báo FirebaseAuth

  // Lưu dữ liệu người dùng vào Firestore
  Future<void> saveUserAddresses({
    required String name,
    required String phone,
    required String address,
    required String note,
    required String addressType,
    required bool isDefault,
  }) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final String uid = user.uid;

      if (isDefault) {
        final snapshot = await _firestore
            .collection('users')
            .where('uid', isEqualTo: uid)
            .get();

        for (var doc in snapshot.docs) {
          await _firestore.collection('users').doc(doc.id).update({
            'isDefault': false,
          });
        }
      }

      await _firestore.collection('users').add({
        'uid': uid, // Lưu uid của người dùng
        'name': name,
        'phone': phone,
        'address': address,
        'note': note,
        'addressType': addressType,
        'isDefault': isDefault,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Dữ liệu đã được lưu thành công!');
    } catch (e) {
      print('Lỗi khi lưu dữ liệu: $e');
      throw Exception('Không thể lưu dữ liệu');
    }
  }

  // Cập nhật địa chỉ người dùng
  Future<void> updateUserAddress({
    required String id,
    required String name,
    required String phone,
    required String address,
    required String note,
    required String addressType,
    required bool isDefault,
  }) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }
      final String uid = user.uid;

      // Nếu địa chỉ được đặt làm mặc định, cập nhật các địa chỉ khác thành không mặc định
      if (isDefault) {
        final snapshot = await _firestore
            .collection('users')
            .where('uid', isEqualTo: uid)
            .get();

        for (var doc in snapshot.docs) {
          await _firestore.collection('users').doc(doc.id).update({
            'isDefault': false,
          });
        }
      }
      
      await _firestore.collection('users').doc(id).update({
        'name': name,
        'phone': phone,
        'address': address,
        'note': note,
        'addressType': addressType,
        'isDefault': isDefault,
      });

      notifyListeners();
    } catch (e) {
      print('Lỗi khi cập nhật địa chỉ: $e');
      throw Exception('Không thể cập nhật địa chỉ');
    }
  }

  // Lấy danh sách địa chỉ từ Firestore
  Future<List<UserAddress>> getUserAddresses() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final String uid = user.uid;

      // Lọc dữ liệu theo uid
      final snapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid) // Lọc theo uid
          .get();

      final address = snapshot.docs
          .map((doc) => UserAddress.fromMap(doc.id, doc.data()))
          .toList();
      // Sắp xếp danh sách: Địa chỉ mặc định lên đầu
    address.sort((a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));
      return address;
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
      throw Exception('Không thể lấy dữ liệu');
    }
  }

  // lấy địa chỉ mặc địnhđịnh
  Future<UserAddress?> getDefaultAddress() async {
    try {
      final List<UserAddress> addresses = await getUserAddresses();
      return addresses.isNotEmpty ? addresses.first : null;
    } catch (e) {
      print('Lỗi khi lấy địa chỉ mặc định: $e');
      return null;
    }
  }

  // Xóa địa chỉ người dùng
  Future<void> deleteUserAddress(String id) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      await _firestore.collection('users').doc(id).delete();
      notifyListeners();
      print('Địa chỉ đã được xóa thành công!');
    } catch (e) {
      print('Lỗi khi xóa địa chỉ: $e');
      throw Exception('Không thể xóa địa chỉ');
    }
  }
}