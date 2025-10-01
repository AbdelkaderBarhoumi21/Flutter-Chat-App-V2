import 'package:chatify/models/chat_model.dart';
import 'package:chatify/models/chatuser_model.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UserspageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _db;
  late NavigationService _navigationService;
  List<ChatUserModel>? users;
  late List<ChatUserModel> _selectedUsers;
  List<ChatUserModel>? get selectedUsers {
    return _selectedUsers;
  }

  UserspageProvider(this._auth) {
    _selectedUsers = [];
    _db = GetIt.instance.get<DatabaseService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    getUsers();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _db.getUsers(name: name).then((snapshot) {
        users =
            snapshot.docs.map((doc) {
              Map<String, dynamic> _data = doc.data() as Map<String, dynamic>;
              _data['uid'] = doc.id; // the document id added to data;
              return ChatUserModel.fromJSON(_data);
            }).toList();
        notifyListeners();
      });
    } catch (e) {
      print('Error getting users');
      print(e);
    }
  }

  void updateSelectedUser(ChatUserModel _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      //create chat
      List<String> _memberIds =
          _selectedUsers.map((_user) => _user.uid).toList();
      _memberIds.add(_auth.chatUserModel.uid); //add the current user
      bool _isGroup = _selectedUsers.length > 1;
      DocumentReference? _doc = await _db.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _memberIds,
      });
      //navigate to chat page
      List<ChatUserModel> _members = [];
      for (var _uid in _memberIds) {
        DocumentSnapshot _userSnapShot = await _db.getuser(_uid);
        Map<String, dynamic> _userData =
            _userSnapShot.data() as Map<String, dynamic>;
        _userData['uid'] = _userSnapShot.id;
        _members.add(ChatUserModel.fromJSON(_userData));
      }
      ChatPage _chatPage = ChatPage(
        chat: ChatModel(
          uid: _doc!.id,
          currentuserId: _auth.chatUserModel.uid,
          members: _members,
          messages: [],
          activity: false,
          group: _isGroup,
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigationService.navigateToPage(_chatPage);
    } catch (e) {
      print("Error creating chat");
      print(e);
    }
  }
}
