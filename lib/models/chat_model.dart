import 'package:chatify/models/chatmessages_model.dart';
import 'package:chatify/models/chatuser_model.dart';

class ChatModel {
  final String uid;
  final String currentuserId;
  final bool activity;
  final bool group;
  final List<ChatUserModel> members;

  List<ChatmessagesModel> messages;
  late final List<ChatUserModel> recepients;
  ChatModel({
    required this.uid,
    required this.currentuserId,
    required this.members,
    required this.messages,
    required this.activity,
    required this.group,
  }) {
    recepients = members.where((i) => i.uid != currentuserId).toList();
  }
  List<ChatUserModel> receipents() {
    return recepients;
  }

  String title() {
    return !group
        ? recepients.first.name
        : recepients.map((user) => user.name).join(", ");
  }

  String imageUrl() {
    return !group
        ? recepients.first.imageUrl
        : "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png";
  }
}
