import 'package:chatify/models/chat_model.dart';
import 'package:chatify/models/chatmessages_model.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/chatpage_provider.dart';
import 'package:chatify/widgets/customTextFormField.dart';
import 'package:chatify/widgets/custom_listviewtiles.dart';
import 'package:chatify/widgets/customtopbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final ChatModel chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double deviceheight;
  late double deviceWidth;
  late AuthenticationProvider auth;
  late ChatProvider chatProvider;

  late GlobalKey<FormState> messqgeFormState;
  late ScrollController messageListViewController;

  late TextEditingController messageController;

  @override
  void initState() {
    messqgeFormState = GlobalKey<FormState>();
    messageListViewController = ScrollController();
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceheight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatProvider>(
          create:
              (_) => ChatProvider(
                widget.chat.uid,
                auth,
                messageListViewController,
              ),
        ),
      ],
      child: _buildUi(),
    );
  }

  Widget _buildUi() {
    return Builder(
      builder: (BuildContext context) {
        chatProvider = context.watch<ChatProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.03,
                vertical: deviceheight * 0.02,
              ),
              height: deviceheight,
              width: deviceheight * 0.97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTopBar(
                    barTitle: widget.chat.title(),
                    fontSize: 15,
                    primaryAction: IconButton(
                      onPressed: () {
                        chatProvider.deleteChat();
                      },
                      icon: Icon(Icons.delete, color: Colors.blue),
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {
                        chatProvider.goback();
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.blue),
                    ),
                  ),
                  _messagesListView(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (chatProvider.messages != null) {
      if (chatProvider.messages!.isNotEmpty) {
        return SizedBox(
          height: deviceheight * 0.74,
          child: ListView.builder(
            controller: messageListViewController,
            itemCount: chatProvider.messages!.length,
            itemBuilder: (BuildContext context, index) {
              ChatmessagesModel message = chatProvider.messages![index];
              bool isOwnMessage = message.senderId == auth.chatUserModel.uid;
              return Container(
                child: CustomChatListViewTile(
                  deviceheight: deviceheight,
                  width: deviceWidth * 0.80,
                  isOwnMessage: isOwnMessage,
                  message: message,
                  sender:
                      widget.chat.members
                          .where((m) => m.uid == message.senderId)
                          .first,
                ),
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: const Text(
            "Be the first one to say Hi!",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: deviceheight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceheight * 0.03,
      ),
      child: Form(
        key: messqgeFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messagetextField(),
            _imageMessageButton(),
            _sendMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messagetextField() {
    return SizedBox(
      width: deviceWidth * 0.65,
      child: CustomTextFormField(
        onSaved: (value) {
          chatProvider.message = value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: "Type a message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double size = deviceheight * 0.04;
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
        onPressed: () {
          if (messqgeFormState.currentState!.validate()) {
            messqgeFormState.currentState!.save();
            chatProvider.sendtextMessage();
            messqgeFormState.currentState!.reset();
          }
        },
        icon: Icon(Icons.send, color: Colors.white),
      ),
    );
  }

  Widget _imageMessageButton() {
    double size = deviceheight * 0.04;
    return SizedBox(
      height: size,
      width: size,
      child: FloatingActionButton(
        onPressed: () {
          chatProvider.sendimageMessage();
        },
        backgroundColor: Color.fromRGBO(0, 82, 218, 1.0),
        child: Icon(Icons.camera_enhance, color: Colors.white),
      ),
    );
  }
}
