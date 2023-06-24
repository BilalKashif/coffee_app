import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/data/current_user_data.dart';
import 'package:coffee_app/data/response/auth_status.dart';
import 'package:coffee_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/app_exceptions.dart';

class AuthViewModel extends ChangeNotifier {
  //---------Firebase Instances-------------------------
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  //---------------------------------------------------
  AuthStatus authStatus = AuthStatus.logedOut;

  Future<void> signUp(
      {required String email,
      required String password,
      required String phoneNumber,
      required String userName}) async {
    authStatus = AuthStatus.loading;
    notifyListeners();
    try {
      UserCredential credentials =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel newUser = UserModel(
        userName: userName,
        userEmail: email,
        userId: credentials.user!.uid,
        phoneNumber: phoneNumber,
        address: '',
        loyalityPoints: 0,
        loyalityCardNumber: 0,
        cardCurrentCount: 0,
        addressLocation: const GeoPoint(31.5204,74.3587),
        isAddressSetted: false,
      );
      CurrentUserData.currentUser = newUser;
      usersCollection.doc(credentials.user!.uid).set(newUser.toJson());
      authStatus = AuthStatus.logedIn;
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      authStatus = AuthStatus.error;
      notifyListeners();
      throw CustomException(error.message, 'Failed to Sign-up');
    } catch (error) {
      authStatus = AuthStatus.error;
      notifyListeners();
      throw CustomException('Something went wrong', 'Error');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    authStatus = AuthStatus.loading;
    notifyListeners();
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot getUser =
          await usersCollection.doc(firebaseAuth.currentUser!.uid).get();
      CurrentUserData.currentUser = UserModel.fromJson(getUser.data() as Map<String, dynamic>);
      authStatus = AuthStatus.logedIn;
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      authStatus = AuthStatus.error;
      notifyListeners();
      throw CustomException(error.message, 'Failed to Login');
    } catch (error) {
      authStatus = AuthStatus.error;
      notifyListeners();
      throw CustomException('Something went wrong', 'Error');
    }
  }
}
