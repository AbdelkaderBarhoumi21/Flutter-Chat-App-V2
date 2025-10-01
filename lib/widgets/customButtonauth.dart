import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final void Function()? onPressed;
  const CustomButtonAuth({
    super.key,
    required this.text,
    required this.onPressed,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: MaterialButton(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 15),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(
          text,
          style: TextStyle(
            height: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
