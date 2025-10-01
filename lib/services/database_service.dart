import 'package:chatify/models/chatmessages_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String userCollection = "Users";
const String ChatsCollecton = "Chats";
const String MessagesCollection = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService();

  Future<void> createUser(
    String uid,
    String email,
    String name,
    String imageURL,
  ) async {
    try {
      await _db.collection(userCollection).doc(uid).set({
        "email": email,
        "name": name,
        "image": imageURL,
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getuser(String uid) {
    return _db.collection(userCollection).doc(uid).get();
  }

  Future<void> updateUserLastSeen(String uid) async {
    try {
      await _db.collection(userCollection).doc(uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getChatsForuser(String uid) {
    return _db
        .collection(ChatsCollecton)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  //avoir -le dernier message
  Future<QuerySnapshot> getLastMessageForChat(chatId) {
    return _db
        .collection(ChatsCollecton)
        .doc(chatId)
        .collection(MessagesCollection)
        .orderBy("sender_time", descending: true)
        .limit(1) //get the first document
        .get();
  }

  //chat function
  Stream<QuerySnapshot> streamMessageForChat(String chatId) {
    return _db
        .collection(ChatsCollecton)
        .doc(chatId)
        .collection(MessagesCollection)
        .orderBy("sender_time", descending: false)
        .snapshots();
  }

  //delete chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _db.collection(ChatsCollecton).doc(chatId).delete();
    } catch (e) {
      print(e);
    }
  }

  //add message to chat
  Future<void> addMessageToChat(
    String chatId,
    ChatmessagesModel message,
  ) async {
    try {
      await _db
          .collection(ChatsCollecton)
          .doc(chatId)
          .collection(MessagesCollection)
          .add(message.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(String chatId, Map<String, dynamic> data) async {
    try {
      await _db.collection(ChatsCollecton).doc(chatId).update(data);
    } catch (e) {
      print(e);
    }
  }

  //users pqge

  Future<QuerySnapshot> getUsers({String? name}) {
    Query _query = _db.collection(userCollection);
    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "\uf8ff");
      // _query = _query
      //     .where("name", isGreaterThanOrEqualTo: name)
      //     .where("name", isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
  }

  //chat create
  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      DocumentReference _chat = await _db.collection(ChatsCollecton).add(_data);
      return _chat;
    } catch (e) {
      print(e);
    }
  }
}
