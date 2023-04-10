import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionModel {
  final String? id ;
  final String type;
  final String lastMessage;
  final DateTime lastMessageDate;
  final String lastMessageStatusAdmin;
  final String lastMessageStatusUser;
  final String? generation ;
  final String phoneNo;
  final String userId;


  const DiscussionModel({
    this.id,
    required this.type,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.lastMessageStatusAdmin,
    required this.lastMessageStatusUser,
    this.generation,
    required this.phoneNo,
    required this.userId,
  });

  toJason(){
    return{
      "Type" : type,
      "LastMessage" : lastMessage,
      "LastMessageDate" : lastMessageDate,
      "LastMessageStatusAdmin" : lastMessageStatusAdmin,
      "LastMessageStatusUser" : lastMessageStatusUser,
      "Generation" : generation,
      "Phone" : phoneNo,
      "UserId" : userId,
    };
  }

  //Map discussion fetched fromFirebase to DiscussionModel
  factory DiscussionModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return DiscussionModel(
      id: document.id,
      type: data["Type"],
      lastMessage: data["LastMessage"],
      lastMessageDate: data["LastMessageDate"],
      lastMessageStatusAdmin: data["LastMessageStatusAdmin"],
      lastMessageStatusUser: data["LastMessageStatusUser"],
      generation: data["Generation"],
      phoneNo: data["Phone"],
      userId: data["UserId"],
    );
  }

}