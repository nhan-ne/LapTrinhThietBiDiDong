import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:flutter/material.dart';

class Booking {
  final String id;
  final String customerName;
  final String phone;
  final String catName;
  final String breed;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String roomType;
  final String notes;

  Booking({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.catName,
    required this.breed,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomType,
    required this.notes,
  });

  factory Booking.fromMap(String id, Map<String, dynamic> data) {
    return Booking(
      id: id,
      customerName: data['customerName'],
      phone: data['phone'],
      catName: data['catName'],
      breed: data['breed'],
      checkInDate: (data['checkInDate'] as Timestamp).toDate(),
      checkOutDate: (data['checkOutDate'] as Timestamp).toDate(),
      roomType: data['roomType'],
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phone': phone,
      'catName': catName,
      'breed': breed,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'roomType': roomType,
      'notes': notes,
    };
  }
}