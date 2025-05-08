import 'package:flutter/material.dart'; // Import TimeOfDay
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Timestamp

class Appointment {
  final String id;
  final String petName;
  final String breed;
  final DateTime date;
  final TimeOfDay time;
  final String reason;
  final String note;
  final String veterinaryName;
  String? uid;

  Appointment({
    required this.id,
    required this.petName,
    required this.breed,
    required this.date,
    required this.time,
    required this.reason,
    required this.note,
    required this.veterinaryName,
    this.uid,
  });

  factory Appointment.fromMap(String id, Map<String, dynamic> data) {
    return Appointment(
      id: id,
      petName: data['petName'],
      breed: data['breed'],
      date: (data['date'] as Timestamp).toDate(), // Sử dụng Timestamp
      time: TimeOfDay.fromDateTime((data['time'] as Timestamp).toDate()),
      reason: data['reason'],
      note: data['note'],
      veterinaryName: data['veterinaryName'],
      uid: data['uid'],
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
      'uid': uid,
      'veterinaryName': veterinaryName,
    };
  }
}