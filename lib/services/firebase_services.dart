import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService{
  static FirebaseFirestore db= FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;


}