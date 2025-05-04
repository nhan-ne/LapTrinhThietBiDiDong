import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/cat_hotel_model.dart';
import '../../models/booking.dart'; // Import model Booking

class CatHotelViewModel extends ChangeNotifier {
  List<CatHotel> _originalCatHotelData = [];
  List<CatHotel> _filteredCatHotelData = [];
  TextEditingController searchController = TextEditingController();

  List<CatHotel> get filteredCatHotelData => _filteredCatHotelData;

  CatHotelViewModel() {
    loadCatHotelData();
    searchController.addListener(onSearchChanged);
  }

  Future<void> loadCatHotelData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/cathotels.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _originalCatHotelData = jsonList.map((json) => CatHotel.fromJson(json)).toList();
      _filteredCatHotelData = List.from(_originalCatHotelData);
      notifyListeners();
    } catch (e) {
      print('Error loading cat hotel data: $e');
    }
  }

  void onSearchChanged() {
    final String searchText = searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      _filteredCatHotelData = List.from(_originalCatHotelData);
    } else {
      _filteredCatHotelData = _originalCatHotelData
          .where((hotel) =>
          hotel.name.toLowerCase().contains(searchText))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged();
  }

  // Phương thức để lấy danh sách đặt phòng
  Future<List<Booking>> getBookings() async {
    return []; // Tạm thời trả về danh sách trống
  }

  // Phương thức để lưu thông tin đặt phòng
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
    required String catWeight,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'customerName': customerName,
        'phone': phone,
        'catName': catName,
        'breed': breed,
        'checkInDate': checkInDate.toIso8601String(), // Lưu dưới dạng String
        'checkOutDate': checkOutDate.toIso8601String(), // Lưu dưới dạng String
        'roomType': roomType,
        'notes': notes,
        'hotelName': hotelName,
        'catWeight': catWeight,
      });
      print('Booking saved to Firestore');
    } catch (e) {
      print('Error saving booking: $e');
    }
  }

  // Phương thức để xóa đặt phòng
  Future<void> deleteBooking(String? bookingId) async {
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}