import 'package:flutter/material.dart';

class Customtextformauth extends StatelessWidget {
  final String hinText;
  final String labelText;
  final IconData iconData;
  final bool isNumber;
  final bool obscureText;
  final String regEx;
  final void Function()? onTapIcon;
  final TextEditingController? myController;
  const Customtextformauth({
    super.key,
    required this.hinText,
    required this.regEx,
    required this.labelText,
    required this.iconData,
    required this.myController,
    required this.isNumber,
    required this.obscureText,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: TextFormField(
        
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
        ),
        keyboardType: isNumber
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        controller: myController,
        validator: (value) {
          return RegExp(regEx).hasMatch(value!) ? null : "Enter a valid value";
        },
        obscureText: obscureText,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          label: Container(
            margin: const EdgeInsets.symmetric(horizontal: 9),
            child: Text(
              labelText,
              style: TextStyle(
                color: const Color.fromARGB(187, 238, 238, 238),
              ),
            ),
          ),
          hintText: hinText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: const Color.fromARGB(187, 238, 238, 238),
          ),
          suffixIcon: InkWell(
              onTap: onTapIcon,
              child: Icon(
                iconData,
                color: const Color.fromARGB(187, 238, 238, 238),
              )),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  const CustomTextFormField(
      {super.key, required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (value) {
        return RegExp(regEx).hasMatch(value!) ? null : 'Enter a valid value.';
      },
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
      ),
    );
  }
}
class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  CustomTextField(
      {super.key, required this.onEditingComplete,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
      ),
    );
  }
}

