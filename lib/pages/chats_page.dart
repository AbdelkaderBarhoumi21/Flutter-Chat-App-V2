import 'package:chatify/models/chat_model.dart';
import 'package:chatify/models/chatmessages_model.dart';
import 'package:chatify/models/chatuser_model.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/chatspage_provider.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/widgets/custom_listviewtiles.dart';
import 'package:chatify/widgets/customtopbar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double deviceheight;
  late double deviceWidth;
  late AuthenticationProvider auth;
  late ChatsPageProvider chatpageProvider;
  late NavigationService navigationService;
  @override
  Widget build(BuildContext context) {
    deviceheight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigationService = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(auth),
        ),
      ],
      child: _buildUi(),
    );
  }

  Widget _buildUi() {
    return Builder(
      builder: (BuildContext context) {
        chatpageProvider = context.watch<ChatsPageProvider>();

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03,
            vertical: deviceheight * 0.02,
          ),
          height: deviceheight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTopBar(
                barTitle: "Chats",
                fontSize: 30,
                primaryAction: IconButton(
                  onPressed: () {
                    auth.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 128, 1.0),
                  ),
                ),
              ),
              _chatslist(),
            ],
          ),
        );
      },
    );
  }

  Widget _chatslist() {
    List<ChatModel>? chats = chatpageProvider.chats;
    print(chats);
    return Expanded(
      child:
          (() {
            if (chats != null) {
              if (chats.isNotEmpty) {
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (BuildContext context, index) {
                    return _chatTile(chats[index]);
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "No chats Found.",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
          })(),
    );
  }

  Widget _chatTile(ChatModel chat) {
    List<ChatUserModel> recepients = chat.receipents();
    bool isActive = recepients.any((document) => document.wasRecentlyActive());
    String subtitleText = "";
    if (chat.messages.isNotEmpty) {
      subtitleText =
          chat.messages.first.type != Messagetype.text
              ? "Media Attachement"
              : chat.messages.first.content;
    }
    return CustomListviewtiles(
      height: deviceheight * 0.1,
      title: chat.title(),
      subtitle: subtitleText,
      imagePath: chat.imageUrl(),

      isActive: isActive,
      isSelected: chat.activity,
      onTap: () {
        navigationService.navigateToPage(ChatPage(chat: chat));
      },
    );
  }
}
