import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uid;
  final String? email;

  UserModel({this.uid, this.email});

  User? toFirebaseUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
