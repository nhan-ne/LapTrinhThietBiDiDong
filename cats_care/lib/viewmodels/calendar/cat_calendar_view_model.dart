import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cat_calendar_model.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class CatCalendarViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<CatEvent> events = [];
  StreamSubscription? _eventSubscription;
  String? catId;


  CatCalendarViewModel(this.catId) {
    if (catId != null) {
      loadEvents(catId!);
    }
  }

  void loadEvents(String catId) {
    this.catId = catId;
    _eventSubscription?.cancel();
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
    _eventSubscription?.cancel();
    super.dispose();
  }



  Future<void> deleteExternalEvent(String catId, String eventId) async {
    try {
      await _firestore.collection('cat_events').doc(eventId).delete();
      notifyListeners();
    } catch (e) {
      print('Lỗi khi xóa sự kiện ngoài: $e');
    }
  }

  Future<void> addExternalEvent(String catId, DateTime date, String title, String note,  String uid) async {
    try {
      await _firestore.collection('cat_events').add({
        'catId': catId,
        'date': date,
        'title': title,
        'note': note,
        'eventType': 'external',
        'uid': uid,
      });
      notifyListeners();
    } catch (e) {
      print('Lỗi khi thêm sự kiện ngoài: $e');
    }
  }

  Future<void> addCatEvent(CatEvent event) async {
    try {
      await _firestore.collection('cat_events').add(event.toMap());
      notifyListeners();
    } catch (e) {
      print('Lỗi khi thêm sự kiện: $e');
    }
  }

  Future<void> updateCatEvent(
      String eventId, Map<String, dynamic> updateData) async {
    try {
      await _firestore.collection('cat_events').doc(eventId).update(updateData);
      notifyListeners();
    } catch (e) {
      print('Lỗi khi cập nhật sự kiện: $e');
    }
  }

  Future<void> deleteCatEvent(String eventId) async {
    try {
      await _firestore.collection('cat_events').doc(eventId).delete();
      notifyListeners();
    } catch (e) {
      print('Lỗi khi xóa sự kiện: $e');
    }
  }

  Future<void> addVaccinationDate(
      String catId, DateTime date, String? title,String uid) async {
    try {
      await _firestore.collection('cat_events').add({
        'catId': catId,
        'vaccinationDate': date,
        'title': title,
        'uid': uid,
      });
      notifyListeners();
    } catch (e) {
      print('Lỗi khi thêm ngày chích ngừa: $e');
    }
  }

  Future<void> addMatingDate(String catId, DateTime date, String? title, String uid) async {
    try {
      await _firestore.collection('cat_events').add({
        'catId': catId,
        'matingDate': date,
        'title': title,
        'uid': uid,
      });
      notifyListeners();
    } catch (e) {
      print('Lỗi khi thêm ngày phối giống: $e');
    }
  }

  Future<void> addHeatDate(
      String catId, DateTime startDate, DateTime? endDate, String? title, String uid) async {
    try {
      await _firestore.collection('cat_events').add({
        'catId': catId,
        'heatStartDate': startDate,
        'heatEndDate': endDate,
        'title': title,
        'uid': uid,
      });
      notifyListeners();
    } catch (e) {
      print('Lỗi khi thêm ngày động dục: $e');
    }
  }

  Future<void> addDeliveryDate(
      String catId, DateTime date, String? title, String uid) async {
    try {
      await _firestore.collection('cat_events').add({
        'catId': catId,
        'deliveryDate': date,
        'title': title,
        'uid': uid,
      });
      notifyListeners();
    } catch (e) {
      print('Lỗi khi thêm ngày sinh đẻ: $e');
    }
  }

  Future<void> updateEvent(String catId, String eventId, DateTime newDate) async {
    try {
      await _firestore
          .collection('cat_events')
          .doc(eventId)
          .update({'date': newDate});
      loadEvents(catId); // Tải lại sự kiện sau khi cập nhật
    } catch (e) {
      print('Lỗi khi cập nhật sự kiện: $e');
    }
  }

  Future<void> deleteEvent(String catId, String eventId) async {
    try {
      await _firestore.collection('cat_events').doc(eventId).delete();
      loadEvents(catId); // Tải lại sự kiện sau khi xóa
    } catch (e) {
      print('Lỗi khi xóa sự kiện: $e');
    }
  }
}