import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/booking.dart';

class BookingViewModel extends ChangeNotifier { // Đã đổi tên class (tùy chọn)
  final CollectionReference _bookings = FirebaseFirestore.instance.collection('bookings');

  Future<void> saveBooking({
    required String customerName,
    required String phone,
    required String catName,
    required String breed,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required String roomType,
    required String notes,
    required String hotelName,
  }) async {
    await _bookings.add({
      'customerName': customerName,
      'phone': phone,
      'catName': catName,
      'breed': breed,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'roomType': roomType,
      'notes': notes,
      'hotelName': hotelName,
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
}