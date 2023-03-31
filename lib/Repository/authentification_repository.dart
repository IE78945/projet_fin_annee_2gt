
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../screens/entryPoint/entry_point.dart';
import '../screens/onboding/onboding_screen.dart';

class AuthentificationRepository extends GetxController {
  static AuthentificationRepository get instance => Get.find();

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

   _setInitialScreen(User? user) {
      user == null ? Get.offAll(() => const OnboardingScreen()) : Get.offAll(() => const EntryPoint());
    }

  Future<bool> CreateUserWithEmailAndPassword(String email, String password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //firebaseUser.value != null ? Get.offAll(() => const OnboardingScreen()) : Get.offAll(() => const EntryPoint());
      return true;
    }on FirebaseAuthException catch(e){
      switch(e.code){
        case 'weak-password':print('Please enter a stronger password');
        case 'invalid-email':print('Email is not valid or badly formatted');
        case 'email-already-in-use':print('An account already exists for that email');
        case 'operation-not-allowed':print('Operation is not allowed. Please contact support.');
        case 'user-disabled':print('This user has been disabled. Please contact support for help.');
        default:print('An unknown error occurred');
      }
      return false;
    }catch(_){
      print('An unknown error occurred');
      return false;
    }
  }

  Future<void> LoginUserWithEmailAndPassword(String email, String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
    }catch(_){}
  }

   Future<void> logout() async => await _auth.signOut();
 }