import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  //---------Firebase Instances-------------------------
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  //---------------------------------------------------

  
}
