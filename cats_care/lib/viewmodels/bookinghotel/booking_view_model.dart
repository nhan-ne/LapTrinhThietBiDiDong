import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/booking.dart';

class BookingViewModel extends ChangeNotifier { // Đã đổi tên class (tùy chọn)
  final CollectionReference _bookings = FirebaseFirestore.instance.collection('bookings');

  Future<void> saveBooking({
    required String uid,
    required String customerName,
    required String phone,
    required String catName,
    required String breed,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required String roomType,
    required String notes,
    required String hotelName,
    required String catWeight,
  }) async {
    await _bookings.add({
      'uid': uid,
      'customerName': customerName,
      'phone': phone,
      'catName': catName,
      'breed': breed,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'roomType': roomType,
      'notes': notes,
      'hotelName': hotelName,
      'catWeight': catWeight,
    });
    notifyListeners();
  }

  Future<List<Booking>> getBookings() async {
    final snapshot = await _bookings.get();
    return snapshot.docs.map((doc) => Booking.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> deleteBooking(String bookingId) async {
    await _bookings.doc(bookingId).delete();
    notifyListeners();
  }

  Future<void> updateBooking({
    required String id,
    required String customerName,
    required String phone,
    required String catName,
    required String breed,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required String roomType,
    required String notes,
    required String hotelName,
    required String catWeight,
  }) async {
    await _bookings.doc(id).update({
      'customerName': customerName,
      'phone': phone,
      'catName': catName,
      'breed': breed,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'roomType': roomType,
      'notes': notes,
      'hotelName': hotelName,
      'catWeight': catWeight,
    });

    notifyListeners();
  }
}