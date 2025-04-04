import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData? icon;
  final TextInputType textInputType;
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.icon,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextSelectionTheme(
        data: TextSelectionThemeData(
          selectionColor: Colors.orange.withOpacity(0.3),
        ),
        child: TextField(
          style: const TextStyle(fontSize: 20, color: Colors.black),
          controller: textEditingController,
          cursorColor: Colors.orange,
          cursorWidth: 2.0,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.black54),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            filled: true,
            fillColor: const Color(0xFFedf0f8),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
          ),
          keyboardType: textInputType,
          obscureText: isPass,
          selectionControls: MaterialTextSelectionControls(),
        ),
      ),
    );
  }
}