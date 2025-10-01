import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  final String barTitle;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final double? fontSize;
  late double deviceHeight;
  late double deviceWidth;
  CustomTopBar({
    super.key,
    required this.barTitle,
    this.primaryAction,
    this.secondaryAction,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return _buildUi();
  }

  Widget _buildUi() {
    return SizedBox(
      height: deviceHeight * 0.10,
      width: deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          _titlebar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget _titlebar() {
    return Text(
      barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
