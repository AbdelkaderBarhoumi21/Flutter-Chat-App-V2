import 'dart:async';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:chatify/models/chatmessages_model.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/cloudstorage_servce.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/media_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class ChatProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudstorageService _cloudstorageService;
  late MediaService _mediaService;
  late NavigationService _navigationService;

  AuthenticationProvider _auth;
  ScrollController _messageListViewController;
  String _chatId;
  List<ChatmessagesModel>? messages;
  String? _message;

  String get message {
    return message;
  }

  void set message(String _value) {
    _message = _value;
  }

  late StreamSubscription _messagesStream; //messzge stream
  late StreamSubscription _keyboardVisibiltyStream; //keyboard visibilty stream
  late KeyboardVisibilityController _keyboardVisibilityController;

  ChatProvider(this._chatId, this._auth, this._messageListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _cloudstorageService = GetIt.instance.get<CloudstorageService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessage();
    listenToKeyboardChanges();
  }
  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void goback() {
    _navigationService.goback();
  }

  void listenToMessage() {
    try {
      _messagesStream = _db.streamMessageForChat(_chatId).listen((_snapshot) {
        List<ChatmessagesModel> _messages =
            _snapshot.docs.map((_doc) {
              Map<String, dynamic> _messageData =
                  _doc.data() as Map<String, dynamic>;
              return ChatmessagesModel.fromJSON(_messageData);
            }).toList();

        messages = _messages;
        print("STREAM → messages récupérés (${messages!.length} éléments)");

        notifyListeners();
        //Add Scroll to bottom call
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messageListViewController.hasClients) {
            _messageListViewController.jumpTo(
              _messageListViewController.position.maxScrollExtent,
            );
          }
        });
      });
    } catch (e) {
      print("Error getting Messages");
      print(e);
    }
  }

  void sendtextMessage() {
    if (_message != null) {
      ChatmessagesModel _messageToSend = ChatmessagesModel(
        senderId: _auth.chatUserModel.uid,
        type: Messagetype.text,
        content: _message!,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendimageMessage() async {
    try {
      // Your image sending logic here
      //upload image to cloud
      PlatformFile? _file = await _mediaService.pickeImageFromLibrary();
      if (_file != null) {
        String? _downloadUrl = await _cloudstorageService
            .saveChatImageToStorage(_chatId, _auth.chatUserModel.uid, _file);
        ChatmessagesModel _messageToSend = ChatmessagesModel(
          senderId: _auth.chatUserModel.uid,
          type: Messagetype.image,
          content: _downloadUrl!,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print("Error Sending image message");
      print(e);
    }
  }

  void deleteChat() {
    goback();
    _db.deleteChat(_chatId);
  }

  void listenToKeyboardChanges() {
    _keyboardVisibiltyStream = _keyboardVisibilityController.onChange.listen((
      _event,
    ) {
      _db.updateChatData(_chatId, {"is_activity": _event});
    });
  }
}
