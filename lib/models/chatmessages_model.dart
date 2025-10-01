import 'package:cloud_firestore/cloud_firestore.dart';

enum Messagetype { text, image, none }

class ChatmessagesModel {
  final String senderId;
  final Messagetype type;
  final String content;
  final DateTime sentTime;
  ChatmessagesModel({
    required this.senderId,
    required this.type,
    required this.content,
    required this.sentTime,
  });

  factory ChatmessagesModel.fromJSON(Map<String, dynamic> json) {
    Messagetype messagetype;
    switch (json['type']) {
      case "text":
        messagetype = Messagetype.text;
        break;
      case "image":
        messagetype = Messagetype.image;
        break;
      default:
        messagetype = Messagetype.none; // Valeur par défaut
    }

    return ChatmessagesModel(
      senderId: json['sender_id'],
      type: messagetype,
      content: json['content'],
      sentTime: json['sender_time'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    String messagetype;

    switch (type) {
      case Messagetype.text:
        messagetype = "text";
        break;
      case Messagetype.image:
        messagetype = "image";
        break;
      default:
        messagetype = "";
    }
    return {
      "content": content,
      "type": messagetype,
      "sender_id": senderId,
      "sender_time": Timestamp.fromDate(sentTime),
    };
  }
}
