import 'package:flutter/material.dart'; // Import TimeOfDay
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Timestamp

class Appointment {
  final String id;
  final String petName;
  final String breed;
  final DateTime date;
  final TimeOfDay time; // Sử dụng TimeOfDay
  final String reason;
  final String note;

  Appointment({
    required this.id,
    required this.petName,
    required this.breed,
    required this.date,
    required this.time, // Sử dụng TimeOfDay
    required this.reason,
    required this.note,
  });

  factory Appointment.fromMap(String id, Map<String, dynamic> data) {
    return Appointment(
      id: id,
      petName: data['petName'],
      breed: data['breed'],
      date: (data['date'] as Timestamp).toDate(), // Sử dụng Timestamp
      time: TimeOfDay.fromDateTime((data['time'] as Timestamp).toDate()), // Sử dụng Timestamp và TimeOfDay
      reason: data['reason'],
      note: data['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'petName': petName,
      'breed': breed,
      'date': date,
      'time': DateTime(date.year, date.month, date.day, time.hour, time.minute),
      'reason': reason,
      'note': note,
    };
  }
}