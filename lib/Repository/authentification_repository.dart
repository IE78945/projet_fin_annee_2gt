
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
    print("------------------------------------------");
    print(user);
      user == null ? Get.offAll(() => const OnboardingScreen()) : Get.offAll(() => const EntryPoint());
    }

  Future<bool> CreateUserWithEmailAndPassword(String email, String password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //firebaseUser.value != null ? Get.offAll(() => const OnboardingScreen()) : Get.offAll(() => const EntryPoint());
      return true;
    }on FirebaseAuthException catch(e){
      switch(e.code){
        case 'weak-password':print('Please enter a stronger password');break;
        case 'invalid-email':print('Email is not valid or badly formatted');break;
        case 'email-already-in-use':print('An account already exists for that email');break;
        case 'operation-not-allowed':print('Operation is not allowed. Please contact support.');break;
        case 'user-disabled':print('This user has been disabled. Please contact support for help.');break;
        default:print('An unknown error occurred');
      }
      return false;
    }catch(_){
      print('An unknown error occurred');
      return false;
    }
  }

  Future<bool> LoginUserWithEmailAndPassword(String email, String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }on FirebaseAuthException catch(e){
      print(e.message);
      return false;
    }catch(_){
      return false;}
  }

  Future<bool> ForgotPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    }on FirebaseAuthException catch(e){ return false;
    }catch(_){return false;}
  }

   Future<void> logout() async => await _auth.signOut();
 }