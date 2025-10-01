import 'package:chatify/models/chatuser_model.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/userspage_provider.dart';
import 'package:chatify/widgets/customButtonauth.dart';
import 'package:chatify/widgets/customTextFormField.dart';
import 'package:chatify/widgets/custom_listviewtiles.dart';
import 'package:chatify/widgets/customtopbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _devicewidth;
  late AuthenticationProvider _auth;
  late UserspageProvider _userspageProvider;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserspageProvider>(
          create: (_) => UserspageProvider(_auth),
        ),
      ],
      child: _Buildui(),
    );
  }

  Widget _Buildui() {
    return Builder(
      builder: (BuildContext _context) {
        _userspageProvider = _context.watch<UserspageProvider>();
        return Container(
          height: _deviceHeight * 0.98,
          width: _devicewidth * 0.97,
          padding: EdgeInsets.symmetric(
            horizontal: _devicewidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTopBar(
                barTitle: "Users",
                fontSize: 30,
                primaryAction: IconButton(
                  onPressed: () {
                    _auth.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 128, 1.0),
                  ),
                ),
              ),
              CustomTextField(
                onEditingComplete: (_value) {
                  _userspageProvider.getUsers(name: _value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: _searchController,
                icon: Icons.search,
              ),
              _usersList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _usersList() {
    List<ChatUserModel>? _users = _userspageProvider.users;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.length != 0) {
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext _context, index) {
                return CustomUserListViewTile(
                  height: _deviceHeight * 0.10,
                  title: _users[index].name,
                  subtitle: "Last Active: ${_users[index].lastDayActive()} ",
                  imagePath: _users[index].imageUrl,
                  isActive: _users[index].wasRecentlyActive(),
                  isSelected:
                      _userspageProvider.selectedUsers!.contains(_users[index])
                          ? true
                          : false,

                  onTap: () {
                    _userspageProvider.updateSelectedUser(_users[index]);
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "No users foound",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
      }(),
    );
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _userspageProvider.selectedUsers!.isNotEmpty,
      child: CustomButtonAuth(
        text:
            _userspageProvider.selectedUsers!.length == 1
                ? "Chat With${_userspageProvider.selectedUsers!.first.name}"
                : "Create Group",
        height: _deviceHeight * 0.05,
        width: _devicewidth * 0.80,
        onPressed: () {
          _userspageProvider.createChat();
        },
      ),
    );
  }
}
