// lib/models/cat_calendar_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CatEvent {
  String? id;
  String? catId;
  String? title;
  DateTime? date;
  String? color;
  String? description;
  DateTime? vaccinationDate;
  DateTime? matingDate;
  DateTime? heatStartDate;
  DateTime? heatEndDate;
  DateTime? deliveryDate;
  bool? heatStarted;
  bool? deliveryStarted;

  CatEvent({
    this.id,
    this.catId,
    this.title,
    this.date,
    this.color,
    this.description,
    this.vaccinationDate,
    this.matingDate,
    this.heatStartDate,
    this.heatEndDate,
    this.deliveryDate,
    this.heatStarted,
    this.deliveryStarted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catId': catId,
      'title': title,
      'date': date,
      'color': color,
      'description': description,
      'vaccinationDate': vaccinationDate,
      'matingDate': matingDate,
      'heatStartDate': heatStartDate,
      'heatEndDate': heatEndDate,
      'deliveryDate': deliveryDate,
      'heatStarted': heatStarted,
      'deliveryStarted': deliveryStarted,
    };
  }

  factory CatEvent.fromMap(Map<String, dynamic> map) {
    return CatEvent(
      id: map['id'],
      catId: map['catId'],
      title: map['title'],
      date: map['date'] != null ? (map['date'] as Timestamp).toDate() : null,
      color: map['color'],
      description: map['description'],
      vaccinationDate: map['vaccinationDate'] != null ? (map['vaccinationDate'] as Timestamp).toDate() : null,
      matingDate: map['matingDate'] != null ? (map['matingDate'] as Timestamp).toDate() : null,
      heatStartDate: map['heatStartDate'] != null ? (map['heatStartDate'] as Timestamp).toDate() : null,
      heatEndDate: map['heatEndDate'] != null ? (map['heatEndDate'] as Timestamp).toDate() : null,
      deliveryDate: map['deliveryDate'] != null ? (map['deliveryDate'] as Timestamp).toDate() : null,
      heatStarted: map['heatStarted'],
      deliveryStarted: map['deliveryStarted'],
    );
  }
}