import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool obscureText;
  final String hintText;
  const MyTextfield({
    super.key,
    required this.controller,
    required this.title,
    required this.obscureText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Text(title),

        SizedBox(height: 5),

        // textfield
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(filled: true, hintText: hintText),
          maxLines: obscureText ? 1 : null,
        ),
      ],
    );
  }
}
