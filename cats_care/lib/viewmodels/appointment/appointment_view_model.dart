import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: duplicate_import
import 'package:flutter/material.dart';
// ignore: duplicate_import
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: duplicate_import
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/Appointment.dart';


class AppointmentViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lưu lịch khám vào Firestore
  Future<void> saveAppointment({
    required String petName,
    required String breed,
    required DateTime date,
    required TimeOfDay time,
    required String reason,
    required String note,
    required String veterinaryName,
    String? name, // Ví dụ: tham số này có thể null
    String? phone,
    String? vaccinationHistory,
    String? medicalHistory,
    String? currentSymptoms,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final String uid = user.uid;

      await _firestore.collection('appointments').add({
        'veterinaryName': veterinaryName,
        'uid': uid,
        'petName': petName,
        'breed': breed,
        'date': date,
        'time': DateTime(date.year, date.month, date.day, time.hour, time.minute),
        'reason': reason,
        'note': note,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Lịch khám đã được lưu thành công!');
    } catch (e) {
      print('Lỗi khi lưu lịch khám: $e');
      throw Exception('Không thể lưu lịch khám');
    }
  }

  // Lấy danh sách lịch khám từ Firestore
  Future<List<Appointment>> getAppointments() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final String uid = user.uid;

      final snapshot = await _firestore
          .collection('appointments')
          .where('uid', isEqualTo: uid)
          .get();

      return snapshot.docs
          .map((doc) => Appointment.fromMap(doc.id, doc.data()!))
          .toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách lịch khám: $e');
      throw Exception('Không thể lấy danh sách lịch khám');
    }
  }

  // Cập nhật thông tin lịch khám
  Future<void> updateAppointment({
    required String id,
    required String petName,
    required String breed,
    required DateTime date,
    required TimeOfDay time,
    required String reason,
    required String note,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      await _firestore.collection('appointments').doc(id).update({
        'petName': petName,
        'breed': breed,
        'date': date,
        'time': DateTime(date.year, date.month, date.day, time.hour, time.minute),
        'reason': reason,
        'note': note,
      });

      notifyListeners();
    } catch (e) {
      print('Lỗi khi cập nhật lịch khám: $e');
      throw Exception('Không thể cập nhật lịch khám');
    }
  }

  // Xóa lịch khám
  Future<void> deleteAppointment(String id) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      await _firestore.collection('appointments').doc(id).delete();
      notifyListeners();
    } catch (e) {
      print('Lỗi khi xóa lịch khám: $e');
      throw Exception('Không thể xóa lịch khám');
    }
  }
}