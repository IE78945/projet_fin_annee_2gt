import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id ;
  final String firstName;
  final String email;
  final String phoneNo;

  const UserModel({
    this.id,
    required this.firstName,
    required this.email,
    required this.phoneNo,
  });

  toJason(){
    return{
      "FirstName" : firstName,
      "Email" : email,
      "Phone" : phoneNo,
    };
  }

  //Map user fetched fromFirebase to UserModel
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
        id: document.id,
        firstName: data["FirstName"],
        email: data["Email"],
        phoneNo: data["Phone"],
    );
  }

}