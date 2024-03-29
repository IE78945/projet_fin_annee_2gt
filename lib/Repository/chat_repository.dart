
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projet_fin_annee_2gt/model/discussions_model.dart';
import 'package:projet_fin_annee_2gt/model/messages_model.dart';
import 'package:projet_fin_annee_2gt/model/user_model.dart';

class ChatRepository extends GetxController{

  static ChatRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  //Store discussion in firestore
  Future<String> createDiscussion(DiscussionModel disc) async {
    String discussionId = "";
    await _db.collection("Chats").add(disc.toJason())
        .then((docRef) => {discussionId = docRef.id})
        .catchError((error, stackTrace){ print(error.toString());});
    return discussionId;
  }

  //Store message in firestore
  Future<bool> addMessage(MessageModel message, String DiscId) async {
    bool b = false;
    await _db.collection("Chats").doc(DiscId).collection("Messages").add(message.toJason()).whenComplete(() => { b = true })
        .catchError((error, stackTrace){ print(error.toString()); b = false; });
    return b;
  }

  // Fetch User discussions in firestore
  Stream<List<DiscussionModel>> getUserDiscussion(String _userId) {
    var _ref = _db.collection("Chats").where("UserId",isEqualTo: _userId).orderBy("LastMessageDate", descending: true);
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
            return DiscussionModel.fromSnapshot(doc);
      }).toList();
    });
  }



}