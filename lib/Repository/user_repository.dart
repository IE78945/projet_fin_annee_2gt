
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projet_fin_annee_2gt/model/user_mode.dart';

class UserRepository extends GetxController{

  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<bool> createUser(UserModel user) async {
    bool b = false;
    await _db.collection("Users").add(user.toJason()).whenComplete(() => { b = true })
        .catchError((error, stackTrace){ print(error.toString()); b = false; });
    return b;
  }


}