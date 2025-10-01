import 'package:chatify/models/chatuser_model.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUserModel chatUserModel;
  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    // _auth.signOut();
    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        // print("Logged In ");
        _databaseService.updateUserLastSeen(_user.uid);
        _databaseService.getuser(_user.uid).then((_snapshot) {
          Map<String, dynamic> _userData =
              _snapshot.data()! as Map<String, dynamic>;
          chatUserModel = ChatUserModel.fromJSON({
            "uid": _user.uid,
            "name": _userData["name"],
            "email": _userData["email"],
            "last_active": _userData["last_active"],
            "image": _userData["image"],
          });
          print(chatUserModel.toMap());
          _navigationService.removeAndNavigatteToRoute('/home');
        });
      } else {
        _navigationService.removeAndNavigatteToRoute('/login');
        print("Not Authenticated");
      }
    });
  }
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print("Error login to firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserWithEmail(String _email, String _password) async {
    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      return _credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during sign-up: ${e.code} | ${e.message}');
      return null;
    } catch (e) {
      print('Unknown error during sign-up: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
