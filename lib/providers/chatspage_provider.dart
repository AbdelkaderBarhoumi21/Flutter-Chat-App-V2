import 'dart:async';

import 'package:chatify/models/chat_model.dart';
import 'package:chatify/models/chatmessages_model.dart';
import 'package:chatify/models/chatuser_model.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;
  late DatabaseService db;
  List<ChatModel>? chats;
  late StreamSubscription chatStream;
  ChatsPageProvider(this.auth) {
    db = GetIt.instance.get<DatabaseService>();
    getChat();
  }
  @override
  void dispose() {
    chatStream.cancel();
    super.dispose();
  }

void getChat() async {
  try {
    chatStream = db.getChatsForuser(auth.chatUserModel.uid).listen((snapshot) async {
      chats = await Future.wait(
        snapshot.docs.map((document) async {
          Map<String, dynamic> chatData = document.data() as Map<String, dynamic>;

          //Get users In chat
          List<ChatUserModel> members = [];
          for (var uid in chatData['members']) {
            DocumentSnapshot userSnapshot = await db.getuser(uid); // user document
            Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
            userData["uid"] = userSnapshot.id; // id of the document
            members.add(ChatUserModel.fromJSON(userData));
          }

          //get the last message for chat
          List<ChatmessagesModel> messages = [];
          QuerySnapshot chatMessage = await db.getLastMessageForChat(document.id);
          if (chatMessage.docs.isNotEmpty) {
            Map<String, dynamic> messageData = chatMessage.docs.first.data()! as Map<String, dynamic>;
            ChatmessagesModel chatmessagesModel = ChatmessagesModel.fromJSON(messageData);
            messages.add(chatmessagesModel);
          }

          //return chat instance
          return ChatModel(
            uid: document.id,
            currentuserId: auth.chatUserModel.uid,
            members: members,
            messages: messages,
            activity: chatData['is_activity'],
            group: chatData['is_group'],
          );
        }).toList(),
      );
      notifyListeners(); //update the UI when data is fetched
    });
  } catch (e) {
    print("Error getting chat");
    print(e);
  }
}

}
