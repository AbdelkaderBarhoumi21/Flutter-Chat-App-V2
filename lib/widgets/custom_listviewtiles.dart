import 'package:chatify/models/chatmessages_model.dart';
import 'package:chatify/models/chatuser_model.dart';
import 'package:chatify/widgets/custom_messagebubles.dart';
import 'package:chatify/widgets/customprofileimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListviewtiles extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;
  const CustomListviewtiles({
    super.key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetworkWithstatus(
        isActive: isActive,
        imagePath: imagePath,
        size: height / 2,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:
          isSelected
              ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(color: Colors.white54, size: height * 0.1),
                ],
              )
              : Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
    );
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double width;
  final double deviceheight;
  final bool isOwnMessage;
  final ChatmessagesModel message;
  final ChatUserModel sender;

  const CustomChatListViewTile({
    super.key,
    required this.deviceheight,
    required this.width,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                imagePath: sender.imageUrl,
                size: width * 0.1,
              )
              : Container(),
          SizedBox(width: width * 0.05),
          message.type == Messagetype.text
              ? TextMessageBubbles(
                isOwnMessage: isOwnMessage,
                message: message,
                height: deviceheight * 0.06,
                width: width,
              )
              : ImageMessageBubbles(
                isOwnMessage: isOwnMessage,
                message: message,
                height: deviceheight * 0.3,
                width: width * 0.55,
              ),
        ],
      ),
    );
  }
}

class CustomUserListViewTile extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;
  const CustomUserListViewTile({
    super.key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      trailing:
          isSelected ? Icon(Icons.person_add, color: Colors.white54) : null,
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetworkWithstatus(
        isActive: isActive,
        imagePath: imagePath,
        size: height / 2,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
