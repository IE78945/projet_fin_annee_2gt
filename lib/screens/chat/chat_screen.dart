import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt/Repository/authentification_repository.dart';
import 'package:projet_fin_annee_2gt/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt/model/discussions_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _authRepo = Get.put(AuthentificationRepository());
  final _chatRepo = Get.put(ChatRepository());

  late double _height ;
  late double _width;

  getUserUid(){
    final uid = _authRepo.firebaseUser.value?.uid;
    if (uid!= null){
      return uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height * 0.75;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Requests",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                    padding: EdgeInsets.only(right: 20,left: 20),
                      child: Container(
                        child: _conversationsListViewWidget(),
                      ),
                ),
            ],
          ),

      ),
    );
  }

  Widget _conversationsListViewWidget() {
    return Builder(
        builder: (context) {
          getUserUid();
          return Container(
            height: _height,
            width: _width,
            child: StreamBuilder<List<DiscussionModel>>(
                stream: _chatRepo.getUserDiscussion(getUserUid()),
                builder: (context, snapshot) {
                  var _data = snapshot.data;
                  return snapshot.hasData ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _data?.length,
                    itemBuilder: (_context, _index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color:Colors.black, width: 2),
                          ),
                          elevation: 5,
                          shadowColor: Colors.grey,
                          child: ListTile(
                            textColor: Colors.white,
                            onTap: () {},
                            title: Text(_data![_index].type,style:TextStyle(color: Colors.black,),),
                            subtitle: Text(
                                _data![_index].lastMessage,
                                style:TextStyle(color: Colors.black,),
                                maxLines: 1,
                            ),
                            trailing: _listTileTrailingWidgets(_data![_index].lastMessageDate,_data![_index].isLastMessageSeenUser),
                          ),
                        ),
                      );
                    },
                  ) :const Center(child: CircularProgressIndicator(),);
                }
            ),
          );
        }
    );
  }


  Widget _listTileTrailingWidgets(DateTime _lastMessageTimestamp , bool _iSeenByUser ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          timeago.format(_lastMessageTimestamp),
          style: TextStyle(fontSize: 15 , color: Colors.black),
        ),
        if (_iSeenByUser == false)
           Container(
             height: 12,
             width: 12,
             decoration:  BoxDecoration(
               color: Colors.lightBlueAccent,
               borderRadius: BorderRadius.circular(100),
             ),
           )
      ],
    );
  }
}
