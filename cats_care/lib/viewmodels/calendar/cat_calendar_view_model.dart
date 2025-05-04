// lib/viewmodels/calendar/cat_calendar_view_model.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cat_calendar_model.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'dart:async'; // Import thư viện async

class CatCalendarViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CatEvent> events = [];
  StreamSubscription? _eventSubscription; // Thêm biến để giữ subscription

  CatCalendarViewModel(String catId) {
    init(catId); // Gọi init trong constructor
  }

  void init(String catId) {
    _eventSubscription = _firestore
        .collection('cat_events')
        .where('catId', isEqualTo: catId)
        .snapshots()
        .listen((snapshot) {
      events.clear();
      for (final doc in snapshot.docs) {
        final event = CatEvent.fromMap(doc.data() as Map<String, dynamic>);
        event.id = doc.id;
        events.add(event);
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel(); // Hủy bỏ subscription khi ViewModel bị hủy
    super.dispose();
  }

  Future<void> addCatEvent(CatEvent event) async {
    try {
      await _firestore.collection('cat_events').add(event.toMap());
      print('Đã thêm sự kiện: ${event.title}');
      notifyListeners();
    } catch (e) {
      print('Lỗi khi thêm sự kiện: $e');
    }
  }

  Future<void> updateCatEvent(String eventId, Map<String, dynamic> updateData) async {
    try {
      await _firestore.collection('cat_events').doc(eventId).update(updateData);
      print('Đã cập nhật sự kiện có ID: $eventId');
      notifyListeners();
    } catch (e) {
      print('Lỗi khi cập nhật sự kiện: $e');
    }
  }

  Future<void> deleteCatEvent(String eventId) async {
    try {
      await _firestore.collection('cat_events').doc(eventId).delete();
      print('Đã xóa sự kiện có ID: $eventId');
      notifyListeners();
    } catch (e) {
      print('Lỗi khi xóa sự kiện: $e');
    }
  }

  // Các hàm tính toán ngày dự kiến:

  DateTime? calculateNextHeatDate(DateTime? lastHeatDate, bool hasMated, bool hasGivenBirth) {
    if (lastHeatDate == null) return null;
    if (hasMated) return null; // Nếu đã phối, không tính kỳ động dục tiếp theo ngay
    if (hasGivenBirth) {
      return lastHeatDate.add(Duration(days: 30)); // 1 tháng sau sinh
    }
    return lastHeatDate.add(Duration(days: 21)); // Chu kỳ trung bình 3 tuần
  }

  DateTime? calculateEstimatedDeliveryDate(DateTime? matingDate) {
    if (matingDate == null) return null;
    return matingDate.add(Duration(days: 63)); // Thai kỳ mèo khoảng 63 ngày
  }

  DateTime? calculateFirstHeatDate(DateTime? birthDate) {
    if (birthDate == null) return null;
    return birthDate.add(Duration(days: 6 * 30)); // Khoảng 6 tháng sau sinh
  }
}