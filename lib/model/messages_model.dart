import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id ;
  final String message;
  final DateTime sentDate;
  final String senderId;
  final String status;
  final String? phoneData;

  const MessageModel({
    this.id,
    required this.senderId,
    required this.sentDate,
    required this.message,
    required this.status,
    this.phoneData,
  });

  toJason(){
    return{
      "SenderId" : senderId,
      "SentDate" : sentDate,
      "Message" : message,
      "Status" : status,
      "PhoneData" : phoneData,
    };
  }

  //Map user fetched fromFirebase to UserModel
  factory MessageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return MessageModel(
      id: document.id,
      senderId: data["SenderId"],
      sentDate: data["SentDate"],
      message: data["Message"],
      status: data["Status"],
      phoneData: data["PhoneData"],
    );
  }

}